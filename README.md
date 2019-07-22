# Ping_Sensor
Смотрит за связью с интернетом. Автоматический пинг (ping).
- Датчик пинга. В трее отрисовывает значок зеленый, желтый, красный в зависимости от того какой пинг. По умолчанию зеленый если пинг меньше 180 мс, желтый меньше 800 мс
- В репозитории лежит готовый .exe (32 bit) и исходники
- Исходиники 84 строки на basic-подобном языке autoit (расширение файла .au3). Если меняете код, то чтобы перекомпилировать .exe скачайте компилятор с официального сайта: https://www.autoitscript.com/site/autoit/downloads/
- В исходниках куча комментов
- При хорошим соединении значок на мнгновение в ритм сердца моргает красаньненьким. Это ~~баг~~  фича.

По вопросам - пишите на почту.
Зачем это приложение, если такое уже есть? Я не нашел, проще написать самому ;)


![HowToSee](data:image/png;base64,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)
