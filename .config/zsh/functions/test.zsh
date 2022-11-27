#!/usr/bin/zsh


DE="DIOS"

if [ $DE != "ADIOS" ]; then
    function testingzsh() {
        local testing="HOLA"
        echo $myvar
    }
    
    function _testing() {
        echo $myvar
    }
fi
