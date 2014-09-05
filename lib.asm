print:
  push bp
  mov bp, sp
  push ax
  push bx
  mov ah, 0x0e
  mov bx, [bp+4] ;; two values on the stack (old bp, plus ip)
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
