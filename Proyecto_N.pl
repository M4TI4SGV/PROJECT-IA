% Definición de Entidades y Conexiones
espacio(habitacion1).
espacio(habitacion2).
entre_espacios(habitacion1, habitacion2).
entre_espacios(habitacion2, habitacion1).

% Definición de los Objetos
objeto(caja_azul).
objeto(caja_roja).

% Hechos dinámicos para actualizar en tiempo de ejecución
:- dynamic posicion/2, objetivo/1.
posicion(robot, habitacion1).
posicion(caja_azul, habitacion1).
posicion(caja_roja, habitacion1).

objetivo(habitacion2).

% Acciones: Mover y Manipular Objetos
trasladar(Entidad, Desde, Hacia) :-
    entre_espacios(Desde, Hacia),
    retract(posicion(Entidad, Desde)),
    assertz(posicion(Entidad, Hacia)).

tomar(Robot, Caja) :-
    posicion(Caja, Ubicacion),
    posicion(Robot, Ubicacion),
    retract(posicion(Caja, Ubicacion)),
    assertz(posicion(Caja, Robot)).

dejar(Robot, Caja) :-
    posicion(Robot, UbicacionRobot),
    retract(posicion(Caja, Robot)),
    assertz(posicion(Caja, UbicacionRobot)).

% Resolver el Problema
resolver_problema :-
    writeln("Inicio de la solución"),
    tomar(robot, caja_azul),
    writeln("Robot ha tomado la caja azul."),
    % Aplicamos la heurística para determinar el camino
    heuristica(habitacion1, Camino, _),
    writeln("Camino encontrado: "),
    writeln(Camino),
    mover_robot_segun_camino(Camino),
    dejar(robot, caja_azul),
    writeln("Robot ha dejado la caja azul en la ubicación final."),
    posicion(caja_azul, UbicacionFinal),
    format("La caja azul ahora está en: ~w", [UbicacionFinal]), !.

% Heurística y Búsqueda
heuristica(Inicio, Camino, Longitud) :-
    busquedaEnAnchura([[Inicio]], CaminoReverso),
    reverse(CaminoReverso, Camino),
    length(Camino, Longitud).

busquedaEnAnchura([[Nodo | Camino] | _], [Nodo | Camino]) :-
    objetivo(Nodo).

busquedaEnAnchura([CaminoActual | OtrosCaminos], Solucion) :-
    extend(CaminoActual, NuevosCaminos),
    append(OtrosCaminos, NuevosCaminos, CaminosTotales),
    busquedaEnAnchura(CaminosTotales, Solucion).

extend([Nodo | Camino], NuevosCaminos) :-
    findall([NuevoNodo, Nodo | Camino],
            (entre_espacios(Nodo, NuevoNodo), \+ member(NuevoNodo, Camino)), 
            NuevosCaminos).

% Mover el robot según el camino encontrado
mover_robot_segun_camino([_]). % Caso base: estamos en la ubicación objetivo.
mover_robot_segun_camino([Primero, Siguiente | Resto]) :-
    trasladar(robot, Primero, Siguiente),
    format("Moviendo robot de ~w a ~w.\n", [Primero, Siguiente]),
    mover_robot_segun_camino([Siguiente | Resto]).