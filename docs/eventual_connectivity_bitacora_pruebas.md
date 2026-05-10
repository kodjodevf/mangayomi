# Bitácora de pruebas — conectividad eventual (MangaYomi)

Este archivo va **junto** con `eventual_connectivity_analysis.tex`: ahí está la teoría y el juicio; **aquí** registras lo que pasó en tu máquina o dispositivo cuando lo probaste.

## Cómo usarlo

1. Elige **una estrategia** (tabla abajo).
2. Anota **fecha**, **plataforma** (Windows / Android / …) y **versión** de la app si la conoces.
3. Sigue los pasos; rellena **Qué pasó en la práctica** y enlaza o nombra la **captura** (idealmente en `docs/capturas/` con el mismo nombre que sugiere el `.tex`).
4. En **Sustento** escribe en una frase cómo eso respalda (o no) lo que dice el informe.

Cuando termines una estrategia, marca el checklist al inicio de su sección.

---

## Índice rápido


| #   | Estrategia                                      | Tipo                             |
| --- | ----------------------------------------------- | -------------------------------- |
| 1   | Biblioteca / detalle desde datos locales (Isar) | Buena                            |
| 2   | Caché de URLs de páginas del capítulo           | Buena                            |
| 3   | Pull to refresh en detalle                      | Buena                            |
| 4   | Descargas solo Wi‑Fi                            | Buena                            |
| 5   | Reintentos y tiempo máximo (40 s aislado, etc.) | Buena / mixta                    |
| 6   | Sync con servidor propio                        | Débil para eventual connectivity |
| 7   | Errores como texto técnico (toast / pantalla)   | Mala                             |
| 8   | WebView / Cloudflare sin comprobar red          | Mala                             |
| 9   | Mensaje “no pages available” genérico           | Regular                          |


---

## Registro de sesiones (opcional)


| Fecha | Plataforma | Notas generales |
| ----- | ---------- | --------------- |
|       |            |                 |


---

1. Obtener datos manga y novels

Para poder obtener la información que vamos a usar para las pruebas y cargar toda sa información dentro de la pagina, es necesario que 

se selecciono en el boton de more, luego ir a settings, luego buscar Browse  y en manga extensions repo agregar: [https://raw.githubusercontent.com/kodjodevf/mangayomi-extensions/main/index.json](https://raw.githubusercontent.com/kodjodevf/mangayomi-extensions/main/index.json)

En novel extensions repo agregar: 

[https://raw.githubusercontent.com/kodjodevf/mangayomi-extensions/main/novel_index.json](https://raw.githubusercontent.com/kodjodevf/mangayomi-extensions/main/novel_index.json)

con esto en la pestaña de extensions aparecen las extensiones qeu se pueden utilizar para agregar mangas y novelas. De preferencia  para manga pueden escoger: manga Dex  y para novelas Web Novel Translations. Estas van a mostrar titulos con sus respectivos capitulos y darán informción que srevira para michas de las pruebas

### 1. Biblioteca y detalle con datos locales (Isar)

- Prueba hecha

**Objetivo.** Comprobar que con **sin internet** sigues viendo biblioteca y ficha de obras que **ya** tenías guardadas.

**Preparación.** 

- Cargar desde manga sources de la vista de browse un manga (en este caso cargamos A brides story, dandole en el corazon para qeu aparezca inLibrary
- Asi msimo cargamos una novela en novel sources llamada trauma center y RNG gamer. 
- Ver que aparezca ficha de obra, capitulos e imagen cuando lo cargamos a la library con internet

**Pasos para el experimento.**

1. Activa modo avión o desactiva Wi‑Fi y datos.
2. Abre biblioteca y entra al detalle de una obra que ya estaba.

**Resultado esperado (informe).** Listas y datos guardados visibles; no pantalla vacía solo por falta de red.

**Qué pasó en la práctica.**

Cuando se abre las diferentes cosas guardades, sale como sale si tuviera intenet y se pude leer todo el capitulo guardado como antes

Cuando se hace tanto con manga como con novela, sale lo que se quedo guardado

**Captura sugerida:** `capturas/manga_biblioteca_offline_normal.png,`

`capturas/novel_biblioteca_offline_normal.png`





---

### 2. Caché de lista de páginas del capítulo

- Prueba hecha

**Objetivo.** Tras abrir un capítulo **con** red, al **volver a abrirlo sin** red, la app reutiliza la lista de páginas guardada (si aplica al mismo `chapter.url`).

**Preparación.**

**Tener Wifi encendido**

**Abrir algun capitulo del manga o novela (nosotros usamos  Abride story)** 

**Pasos.**

1. Con red, abre el capítulo hasta que carguen las páginas (es necesario ir bajando en capitulo mientras sale pagina pro pagina) .
2. Sal del lector.
3. Corta la red (modo avión).
4. Abre el **mismo** capítulo otra vez.

**Resultado esperado (informe).** En muchos casos el lector sigue funcionando sin nueva petición de lista al origen.

**Qué pasó en la práctica.**

*Cuando se abrio, se cargaron todos los capitulos y luego al tenerlo sin internet el lector mostro el capitulo exactamente igual a antes, se pudo leer todo el capitulo a pesar de no tener conexión*

**Captura sugerida:** `capturas/capitulo_relectura_sin_red.png`

`capturas/capitulo_relectura_con_red.png`

**Sustento.**

---

### 3. Pull to refresh en detalle de obra

- Prueba hecha

**Objetivo.** El usuario puede **pedir** actualización manual en la ficha.

**Pasos.**

1. Con red, abre detalle de una obra.
2. Desliza hacia abajo (pull to refresh) hasta que termine.

**Resultado esperado (informe).** Indicador de refresco y actualización sin depender solo del arranque automático.

**Qué pasó en la práctica.**

**Este es el caso, el detail de una obra sale de manera adecuada,**  pero si recargamoshaicendo un pull hacia abajao sale un erorr del tipo Client ExceptionWith socketException en la vista y luego se cierra, pero sale lo cargado coo en el punto 1. ESTO PASO TANTO PARA EL MANDA COMO PARA LA NOVELA 

**Captura sugerida:** 

`capturas/manga_pull_refresh_detalle_exception.png`

`capturas/NOVEL_pull_refresh_detalle_exception.png`

---

### 4. Descargas solo por Wi‑Fi

- Prueba hecha

**Objetivo.** Con la opción activada y **solo datos móviles**, la descarga no debe silenciosamente gastar datos; debe avisar o bloquear.

**Pasos.**

1. En more, entra a settings y en Downloads activ Only on Wifi.
2. Desactiva Wi‑Fi; deja solo datos móviles.
3. Intenta descargar un capítulo.

**Resultado esperado (informe).** Mensaje tipo “solo Wi‑Fi” / no inicia descarga como si nada.

**Qué pasó en la práctica.**

**Efectivaente cuando se seleccionaba un captiulo no dejaba descargarlo cuando usaba datos moviles**

**Captura sugerida:** `capturas/settings_only_wifi.png`

`capturas/only_wifi_alert_download.png`



---

### 5. Reintentos y tiempo máximo (aislado ~40 s, imágenes, etc.)

- Prueba hecha

**Objetivo.** Ver **espera acotada** o reintentos ante fallo (no necesariamente “perfecto”, pero documentable).

**Ideas de provocación.**

- Red muy lenta o dominio bloqueado (firewall / DNS mentiroso en desktop).
- Abrir capítulo que tarde mucho o falle al resolver páginas.

**Qué observar.** Tiempo hasta error o carga; mensajes; si el lector queda en carga infinita en imágenes.

**Qué pasó en la práctica.**

**Cuando estoy en una red nromal y le doy recargar a la library de mangas o novels, me sale un erorr que dice Failed Updating Library (1/2) y empeiza a cargar y depsues desaparece. Esto tambien pasa en la vista de updates cuando se el da en la ruedita de descargar y en todas las demás vistas**

**Captura sugerida:** `capturas/reintento.png`

**Sustento.**

---

### 7. Errores técnicos visibles 

- Prueba hecha

**Objetivo.** Documentar si el usuario ve `SocketException`, stack traces o texto crudo.

**Pasos sugeridos.**

- Entrar sin red a la vista de extensiones de manga o de novelas

**Qué pasó en la práctica.**

*Al entrar a la pagina sale una exception que dice Client Exception with Socket Exception Failed host lookup. Esto aparece en todas las vistas de las extensiones qeu se tengan . Esto pasa tambien en el boton de mundo con lupa en Browse en donde uno puede buscar extensiones, sale la lista de excepciones de cada una de las extensiones ya aagregadas con un ClientException*

**Captura sugerida:** `capturas/error_reload.png`



---

### 8. WebView sin comprobar conectividad

- Prueba hecha

**Objetivo.** Modo avión → abrir vista web desde lector/menú (origen en web, Cloudflare, etc.).

Pasos. 

Entrar a una de las obras cragadas en biblioteca 

Seleccionar el boton de web view 

**Qué pasó en la práctica.**

*Al momento de seleccionar aparece una vista de una pagina que dice pagina web no disponible, no se pudo cargar : ERR_INTENET_DISCONNECTED, como en una vista más de navegador*

**Captura sugerida:** `capturas/webview_sin_red.png`



---

### 9. Lector sin páginas — mensaje genérico

- Prueba hecha

**Objetivo.** Capítulo **sin** haber cargado antes las URLs (sin caché), **sin** red.

**Pasos.**

1. Elige un capítulo que **nunca** abriste en este dispositivo (o borra datos de app si puedes y es aceptable).
2. Sin red, ábrelo.

**Qué pasó en la práctica.**

*Al elegir un capitulo que nunca habia scogido antes aparece una nueva vista la cual solo tiene el ClientExpection wih SocketExeption* 

**Captura sugerida:** `capturas/no_pages_available.png`

---



