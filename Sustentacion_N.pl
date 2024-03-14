% Definición de Entidades y Conexiones
espacio(habitacion1).
espacio(habitacion2).
espacio(habitacion3).
entre_espacios(habitacion1, habitacion2).
entre_espacios(habitacion2, habitacion1).
entre_espacios(habitacion2, habitacion3).
entre_espacios(habitacion3, habitacion2).

% Definición de los Objetos
objeto(caja_azul).
objeto(caja_roja).
objeto(caja_verde).

% Hechos dinámicos para actualizar en tiempo de ejecución
:- dynamic posicion/2.
posicion(robot, habitacion1).
posicion(caja_azul, habitacion1).
posicion(caja_roja, habitacion1).
posicion(caja_verde, habitacion3).

% Acciones: Mover y Manipular Objetos
trasladar(Entidad, Desde, Hacia) :-
    entre_espacios(Desde, Hacia),
    retract(posicion(Entidad, Desde)),
    assertz(posicion(Entidad, Hacia)),
    format("~w movido de ~w a ~w.~n", [Entidad, Desde, Hacia]).

tomar(Robot, Caja) :-
    posicion(Caja, Ubicacion),
    posicion(Robot, Ubicacion),
    retract(posicion(Caja, Ubicacion)),
    assertz(posicion(Caja, Robot)),
    format("~w ha tomado la ~w.~n", [Robot, Caja]).

dejar(Robot, Caja) :-
    posicion(Robot, UbicacionRobot),
    retract(posicion(Caja, Robot)),
    assertz(posicion(Caja, UbicacionRobot)),
    format("~w ha dejado la ~w en ~w.~n", [Robot, Caja, UbicacionRobot]).

% Resolver el Problema
resolver_problema :-
    writeln("Inicio de la solución."),
    % Mueve caja roja a H2
    tomar(robot, caja_roja),
    trasladar(robot, habitacion1, habitacion2),
    dejar(robot, caja_roja),
    % Mueve caja verde a H1
    trasladar(robot, habitacion2, habitacion3),
    tomar(robot, caja_verde),
    trasladar(robot, habitacion3, habitacion2),
    trasladar(robot, habitacion2, habitacion1),
    dejar(robot, caja_verde),
    % Mueve caja azul a H3
    tomar(robot, caja_azul),
    trasladar(robot, habitacion1, habitacion2),
    trasladar(robot, habitacion2, habitacion3),
    dejar(robot, caja_azul),
    verificar_estado_final.

% Verifica el estado final de las cajas
verificar_estado_final :-
    posicion(caja_azul, UbicacionAzul),
    posicion(caja_roja, UbicacionRoja),
    posicion(caja_verde, UbicacionVerde),
    format("Estado final: caja_azul en ~w, caja_roja en ~w, caja_verde en ~w.~n", [UbicacionAzul, UbicacionRoja, UbicacionVerde]).
