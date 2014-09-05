[org 0x7c00]

start:
  mov [BOOT_DRIVE], dl ;; BIOS saved the boot drive to DL. Remember for later.
  mov bp, 0x8000
  mov sp, bp
  jmp main

main:
  push GREETING_MSG
  call print
  add sp, 2 ;; pop arg
  ;; Load 5 sectors to 0x0000(ES):0x9000
  mov ah, 5 ;; number of sectors to load
  mov al, [BOOT_DRIVE] ;; where to load from
  push ax
  push 0x9000
  call disk_load
  add sp, 4 ;; pop 2 args
  push 0x9000
  call print
  add sp, 2
  push 0x9000 + 512
  call print
  jmp hang

%include "lib.asm"

hang:
  jmp $

;; Globals
BOOT_DRIVE:
  db 0

GREETING_MSG:
  db "Hello, world", 0

times 510-($-$$) db 0
dw 0xaa55

db "ABCD"
times 512-4 db 0
db "1234"
times 512-4 db 0
