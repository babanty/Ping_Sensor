; Пингует сайт с целью узнавать какой сейчас пинг
#include <Constants.au3>
#include <String.au3>

Global $SiteName = "2ip.ru" ; Имя сайта на который будет отправляться запросы
Global $CommandForCmd = "ping -t -l 8 -w 2000 " & $SiteName ; команда отправляемая в консоль
Global $timerRed ; переменная для таймера 
; ping - отпарвлять запрос на сайт с целью подсчета времени ответа
; -t  отправлять запрос вечно
; -l 8  отпарвлять 8 байтный пакет
; -w 2000 отправлять запрос раз в 0.2 секунды
Global $GreenTime = 180 ; сколько мс считается хорошим пингом
Global $YellovTime = 800 ; сколько мс максимум считается средним пингом

SetCommandInCMD($CommandForCmd) ; запускаем отпарвку запросов


; Алгоритм такой: в момент прочтения из потока нормального числа в зависимости от числа 
; подствечивать в разные цвета: 0-180мс - зеленый, 181-800 желтый
; если ответ пришел, но нет цифры, то красненьким подсветить
; если в течение 850 мс не было ни зеленого ни желтого значка, то устанавливается красный

Global $sStdOut = ""
Func SetCommandInCMD($iCommand,$iKey = "")
    Local $Process = Run(@ComSpec & " /c " & $iCommand & $iKey, @SystemDir, @SW_SHOW, $STDOUT_CHILD) ; @SW_HIDE открываем консоль с возможностью вывода

While 1
    ; получаем и преобразуем ответ от командной строки
    $sStdOut = StdoutRead($Process) & @CRLF
    If @error Then ExitLoop
    $sStdOut = StringReplace($sStdOut, @CRLF, "")
    $sStdOut = StringReplace($sStdOut, @CR & @CR, @CR)
    $sStdOut = OemToChar($sStdOut)
    ; меняем состояние трея в зависимости от ответа от консоли
    SetStateTray($sStdOut)
    Sleep(5)
WEnd
EndFunc

; Изменить состояние трея в зависимости от сообщения от командной строки
Func SetStateTray($msg)
    Local $numArr = _StringBetween($msg, "время=", "мс")
    if(UBound($numArr) <> 0) then
        Local $num = $numArr[0] ; забираем первое число из массива
        ;MsgBox(0, "Сообщение", $msg)
        ;MsgBox(0, "Число", $num)
        if($num > 0 AND $num <= $GreenTime) then
            TraySetIcon(@ScriptDir & "\green.ico"); меняем трей на зеленый
            $timerRed = TimerInit(); Сбрасываем таймер красного значка
        EndIf

        if($num > $GreenTime AND $num <= $YellovTime) then
            TraySetIcon(@ScriptDir & "\yellow.ico"); меняем трей на желтый
            $timerRed = TimerInit(); Сбрасываем таймер красного значка
        EndIf
        If($num > $YellovTime) Then
            TraySetIcon(@ScriptDir & "\red.ico"); меняем трей на красный
            $timerRed = TimerInit(); Сбрасываем таймер красного значка
        EndIf

    Else ; если в строке ни чего нет
        ; если настало время менять на красный значек
        if(TimerDiff($timerRed) > $YellovTime +50) Then ; больше чем 200 мс ни кто не получал ответа от ping
            TraySetIcon(@ScriptDir & "\red.ico")
            $timerRed = TimerInit(); Сбрасываем таймер красного значка
        EndIf
    EndIf

EndFunc

; Преобразует поток данных от cmd в строку
Func OemToChar($szSrc)
    Local $placeholder
    For $i = 0 To StringLen($szSrc)
        $placeholder &= "  "
    Next
    Local $lRetVal = DllCall("user32.dll", "long", "OemToChar", "str", $szSrc, "str", $placeholder)
    If IsArray($lRetVal) And $lRetVal[0] = 1 Then
        Return SetError(0, 0, $lRetVal[2])
    EndIf

    Return SetError(1, 0, "")
EndFunc
