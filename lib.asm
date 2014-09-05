print:
  push bp
  mov bp, sp
  push ax
  push bx
  mov ah, 0x0e
  mov bx, [bp+4] ;; two 16-bit values on the stack (old bp, plus ip)
print_char:
  mov al, [bx]
  cmp al, 0
  je print_done
  int 0x10
  add bx, 1
  jmp print_char
print_done:
  pop bx
  pop ax
  pop bp ;; aka 'leave'
  ret

;; Read $arg1 sectors from 0,0,1 on disk into memory address ES:$arg2.
disk_load:
  push bp
  mov bp, sp
  push ax
  push bx
  push cx
  push dx
  mov al, [bp+7]
  mov ah, 0x02
;;  mov bx, 0xa000 ;; set ES to 0xa00
;;  mov es, bx
  mov bx, [bp+4] ;; destination of the load
  mov dl, [bp+6] ;; drive
  mov ch, 0x00 ;; cylinder 0
  mov dh, 0x00 ;; head 0
  mov cl, 0x02 ;; second sector (unlike the others, this is 1 indexed)
  int 0x13
  jc read_error ;; if the carry flag is set
  mov bl, [bp+7]
  cmp al, bl ;; al (sectors read) against bl (sectors to read)
  jne not_enough_read
  jmp disk_load_done
read_error:
  push READ_ERROR_MSG
  call print
  jmp $
not_enough_read:
  push NOT_ENOUGH_READ_MSG
  call print
  jmp $
disk_load_done:
  pop dx
  pop cx
  pop bx
  pop ax
  pop bp
  ret

READ_ERROR_MSG:
  db "Disk read error", 0

NOT_ENOUGH_READ_MSG:
  db "Not enough data read", 0
