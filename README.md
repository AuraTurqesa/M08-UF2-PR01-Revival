# flutter_80s_app_clean
A Flutter app for 80s songs and movies.

Este proyecto iba en principio sobre vinos y origenes, pero pensé que hacer una aplicación Revival para los amantes de la música y las películas iba a ser mejor.
Por eso, mantení la estructura inicial:

1. Para la página principal, creé una grid de dos columnas, con Scroll vertical.
2. Para las páginas de música y películas creé una grid de una columna, también con Scroll vertical.
3. Implementé una página de búsqueda, donde puedes escribir carácteres y te saldrán las canciones y películas que contengan esos nombres
o si pulsas uno de los botones de las letras te salen los ítems que empiezan con esa letra.
4. Las letras son una grid de una fila. Tiene Scroll horizontal.
5. Para la búsqueda donde se ven los ítems, hay una lista (objeto de tipo lista)
5. En la versión web se puede pulsar para ir al vídeo de youtube.

Para crear listas, he usado la clase List<Modelo>.
Para crear la grid, he usado, como recomienda Flutter, he usado el GridView.count, asignando el padding, los items, como una lista de ítems
y crossAxisCount, que define el número de columnas que tendrá la grid. El número de filas será el valor entero del total entre las columnas.

Como sólo he podido implementar lo del video en la versión web, haré la demostración desde un IDE online que me permite pasar fácilmente de móbil a web.

