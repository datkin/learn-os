[org 0x7c00]

start:
  mov bp, 0x8000
  mov sp, bp
  jmp main

main:
  push string
  call print
  jmp hang

%include "lib.asm"

hang:
  jmp $

string:
  db "Hello, world", 0

times 510-($-$$) db 0
dw 0xaa55
