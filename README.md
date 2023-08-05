# Docker

Разработка докер образа для собственного сервера.

## Part 1. Готовый докер

- Взять официальный докер образ c nginx командой `docker pull nginx`.

- Проверить наличие докер образа через `docker images`.

- Запустить докер образ через `docker run -d [image_id|repository]`.

- Проверить, что образ запустился через `docker ps`.

![nginx](/images/1_1.png)

- Посмотреть информацию о контейнере через `docker inspect [container_id|container_name]`. 

  - размер контейнера (с флагом -s, в kB));
  ![size](/images/1_3.png)
  - список замапленных портов и ip контейнера.
  ![port, ip](/images/1_2.png)

- Остановить докер образ через `docker stop [container_id|container_name]`.

- Проверить, что образ остановился через `docker ps`.

![stop](/images/1_4.png)

- Запустить докер с замапленными портами 80 и 443 на локальную машину через команду `docker run`.

- Проверить, что в браузере по адресу *localhost:80* доступна стартовая страница nginx

![run](/images/1_5.png)

![nginx](/images/1_6.png)

- Перезапустить докер образ через `docker restart [container_id|repository]`

- Проверить любым способом, что контейнер запустился

![restart](/images/1_7.png)

## Part 2. Операции с контейнером

- Прочитать конфигурационный файл *nginx.conf* внутри докер образа через команду `docker exec [container] [command]`

![conf](/images/1_8.png)

- Создать на локальной машине файл *nginx.conf*, настроить в нем по пути */status* отдачу страницы статуса сервера **nginx**

![my config with status](/images/1_9.png)

- Скопировать созданный файл *nginx.conf* внутрь докер образа через команду `docker cp [src_path] [container]:[dst_path]`

- Перезапустить **nginx** внутри докер образа через команду *exec*

- Проверить, что по адресу *localhost:80/status* отдается страничка со статусом сервера **nginx**

![copy reload](/images/1_10.png)

![status](/images/1_11.png)

- Экспортировать контейнер в файл *container.tar* через команду ` docker export [continer] > container.tar`

![export](/images/1_12.png)

- Остановить контейнер

![stop](/images/1_13.png)

- Удалить образ через `docker rmi [image_id|repository]`, не удаляя перед этим контейнеры

![rmi](/images/1_14.png)

- Импортировать контейнер обратно через команду `docker import [file]`

![import](/images/1_15.png)

- Запустить импортированный контейнер

![import](/images/1_16.png)

## Part 3. Мини веб-сервер

- Написать мини сервер на **C** и **FastCgi**, который будет возвращать простейшую страничку с надписью `Hello World!`

![mini server](/images/3_1.png)

- Написать свой *nginx.conf*, который будет проксировать все запросы с 81 порта на *127.0.0.1:8080*

![81-8080](/images/3_2.png)

- Запустить написанный мини сервер через *spawn-cgi* на порту 8080

`./task_3.sh`

- Проверить, что в браузере по *localhost:81* отдается написанная вами страничка

![hello](/images/3_3.png)

- Положить файл *nginx.conf* по пути *./nginx/nginx.conf* (это понадобиться позже)

![nginx](/images/3_4.png)

## Part 4. Свой докер образ

- Написать свой докер образ, который: 1) собирает исходники мини сервера на FastCgi из Части 3; 2) запускает его на 8080 порту; 3) копирует внутрь образа написанный *./nginx/nginx.conf*; 4) запускает **nginx**.

![dockerfile](/images/4_1.png)

- Собрать написанный докер образ через `docker build` при этом указав имя и тег (`docker build -f Dockerfile_task_4 -t my_docker:version_1.0 .`)

![build](/images/4_2.png)

- Проверить через `docker images`, что все собралось корректно

![images](/images/4_3.png)

- Запустить собранный докер образ с маппингом 81 порта на 80 на локальной машине и маппингом папки *./nginx* внутрь контейнера по адресу, где лежат конфигурационные файлы **nginx**'а (`docker run --name task4 -p 80:81 --mount type=bind,src=<src>,dst=/etc/nginx/nginx.conf -dt my_docker:version_1.0`)

![run](/images/4_4.png)

- Проверить, что по localhost:80 доступна страничка написанного мини сервера

![curl](/images/4_5.png)

- Дописать в *./nginx/nginx.conf* проксирование странички */status*, по которой надо отдавать статус сервера **nginx**

![config](/images/4_6.png)

- Перезапустить докер образ. Если всё сделано верно, то, после сохранения файла и перезапуска контейнера, конфигурационный файл внутри докер образа должен обновиться самостоятельно без лишних действий

![restart](/images/4_7.png)

- Проверить, что теперь по *localhost:80/status* отдается страничка со статусом **nginx**

![curl](/images/4_8.png)

## Part 5. Dockle

- Просканировать контейнер из предыдущего задания через `dockle [container_id|container_name]`

- Исправить контейнер так, чтобы при проверке через **dockle** не было ошибок и предупреждений

<!-- docker rm -f task5
docker rmi my_docker:version_2.0
docker build -f Dockerfile_task_5 -t my_docker:version_2.0 .
docker run --name task5 -p 80:81 -dt my_docker:version_2.0
dockle my_docker:version_2.0
curl http://localhost:80 -->

## Part 6. Docker Compose

- Написать файл *docker-compose.yml*, с помощью которого: 1) Поднять докер контейнер из Части 5 (он должен работать в локальной сети, т.е. не нужно использовать инструкцию **EXPOSE** и мапить порты на локальную машину); 2) Поднять докер контейнер с **nginx**, который будет проксировать все запросы с 8080 порта на 81 порт первого контейнера

- Замапить 8080 порт второго контейнера на 80 порт локальной машины

![compose](/images/6_1.png)

- Остановить все запущенные контейнеры

![stop](/images/6_2.png)

- Собрать и запустить проект с помощью команд `docker-compose build` и `docker-compose up`

![up](/images/6_3.png)

- Проверить, что в браузере по *localhost:80* отдается написанная страничка, как и ранее

![curl](/images/6_4.png)
