
-- 1 - Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes.
-- El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom

SELECT  apellido1, 
        apellido2, 
        nombre
FROM persona
WHERE tipo = 'alumno'
ORDER BY apellido1 DESC, 
        apellido2 DESC, 
        nombre DESC;

   
-- 2 - Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades

SELECT  nombre,
        apellido1,
        apellido2,
        telefono
FROM persona
WHERE telefono IS NULL 
    AND tipo = 'alumno';


-- 3 - Retorna el llistat dels alumnes que van néixer en 1999.

SELECT  nombre,
        apellido1,
        apellido2, 
        fecha_nacimiento
FROM persona
WHERE YEAR(fecha_nacimiento) = 1999 
    AND tipo = 'alumno';


-- 4 - Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K

SELECT  nombre,
        apellido1,
        apellido2,
        tipo,
        telefono
FROM persona
WHERE telefono IS NULL 
    AND tipo = 'profesor'
    AND nif LIKE '%K';


-- 5 - Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7

-- No sé si estoy entendiendo mal el enunciado o es así, pero esto no devuelve nada porque no hay un curso número 3 -_-

SELECT id,
       nombre
FROM asignatura
WHERE cuatrimestre = 1 
    AND curso = 3
    AND id = 4;
    

-- 6 - Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats.
-- El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.

SELECT  persona.apellido1,
        persona.apellido2,
        persona.nombre,
        departamento.nombre
FROM persona
JOIN profesor ON profesor.id_profesor = persona.id
JOIN departamento ON departamento.id = profesor.id_departamento
ORDER BY persona.apellido1 ASC, 
         persona.apellido2 ASC, 
         persona.nombre ASC;


-- 7 - Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M.

SELECT  persona.nif,
        asignatura.nombre,
        curso_escolar.anyo_inicio,
        curso_escolar.anyo_fin
FROM persona
JOIN alumno_se_matricula_asignatura alum ON alum.id_alumno = persona.id
JOIN asignatura ON asignatura.id = alum.id_asignatura
JOIN curso_escolar ON curso_escolar.id = alum.id_curso_escolar
WHERE persona.nif = '26902806M';


-- 8 - Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).

SELECT DISTINCT d.nombre
FROM departamento d
JOIN profesor prof ON prof.id_profesor = d.id
JOIN asignatura a ON a.id_profesor = prof.id_profesor
JOIN grado g ON g.id = a.id_grado
WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';


-- 9 - Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.

SELECT DISTINCT persona.nombre,
                persona.apellido1,
                persona.apellido2
FROM persona
JOIN alumno_se_matricula_asignatura alum ON alum.id_alumno = persona.id
WHERE alum.id_curso_escolar = 5;



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Resol les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN:



-- 1 - Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. 
-- El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom

SELECT  persona.nombre,
        persona.apellido1,
        persona.apellido2,
        departamento.nombre
FROM persona
LEFT JOIN profesor ON profesor.id_profesor = persona.id
LEFT JOIN departamento ON departamento.id = profesor.id_departamento
WHERE persona.tipo = 'profesor'
ORDER BY departamento.nombre ASC,   
        persona.apellido1 ASC, 
        persona.apellido2 ASC, 
        persona.nombre ASC;


-- 2 - Retorna un llistat amb els professors/es que no estan associats a un departament

SELECT  d.nombre AS 'departamento',
        p.nombre,
        p.apellido1,
        p.apellido2
FROM persona p
LEFT JOIN departamento d ON p.id = d.id
WHERE p.tipo = 'profesor'
    AND d.id IS NULL;

   
-- 3 - Retorna un llistat amb els departaments que no tenen professors/es associats

SELECT d.id
FROM departamento d
LEFT JOIN profesor p ON d.id = p.id_departamento
WHERE p.id_profesor IS NULL;

    
-- 4 - Retorna un llistat amb els professors/es que no imparteixen cap assignatura

SELECT  p.nombre,
        p.apellido1,
        p.apellido2
FROM persona p 
LEFT JOIN asignatura a ON p.id = a.id_profesor
WHERE p.tipo = 'profesor' AND a.id IS NULL;

    
-- 5 - Retorna un llistat amb les assignatures que no tenen un professor/a assignat
    
SELECT nombre
FROM asignatura
WHERE id_profesor IS NULL;


-- 6 - Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar

SELECT DISTINCT d.id, d.nombre
FROM departamento d
LEFT JOIN profesor p ON d.id = p.id_departamento
LEFT JOIN asignatura a ON p.id_profesor = a.id_profesor
LEFT JOIN alumno_se_matricula_asignatura alum ON a.id = alum.id_asignatura
GROUP BY d.id , d.nombre
HAVING COUNT(alum.id_curso_escolar) = 0;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Consultes resum:


-- 1 - Retorna el nombre total d'alumnes que hi ha

SELECT COUNT(*) AS 'Total alumnos'
FROM persona
WHERE tipo = 'alumno';



-- 2 - Calcula quants alumnes van néixer en 1999

SELECT COUNT(*) AS 'Alumnos nacidos en 1999'
FROM persona
WHERE tipo = 'alumno'
    AND YEAR(fecha_nacimiento) = 1999;

 
-- 3 - Calcula quants professors/es hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es
  
SELECT  d.nombre AS 'departamento',
        COUNT(p.id_profesor) AS 'Número profesores'
FROM departamento d
JOIN profesor p ON d.id = p.id_departamento
GROUP BY d.nombre
ORDER BY p.id_profesor DESC, d.nombre;

  
-- 4 - Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. 
-- Tingui en compte que poden existir departaments que no tenen professors/es associats. Aquests departaments també han d'aparèixer en el llistat

    
-- 5 -Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. 
-- Tingues en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures


SELECT  g.nombre AS Grado,
        COUNT(a.id) AS Número_Asignaturas
FROM grado g
LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.nombre
ORDER BY Número_Asignaturas DESC, g.nombre;
    

-- 6 - Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades

SELECT  g.nombre AS 'Grado', 
        COUNT(a.id) AS 'Número Asignaturas'
FROM grado g
LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY  g.nombre
HAVING COUNT(a.id) > 40;

    
-- 7 - Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. 
-- El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus
    

-- 8 - Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. 
-- El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats
    
-- 9 - Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures
    
-- 10 - Retorna totes les dades de l'alumne/a més jove
    
-- 11 - Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura

