
section .data
  open_file_err: db "cannot open file", 0xA, 0
  open_file_err_len: equ $-open_file_err
  err_msg: db "error occured", 0xA, 0
  err_msg_len: equ $-err_msg
  buffer_1024: times 1024 db 0

section .text
  global _start
  
_exit:
  mov ebx, eax
  mov eax, 1
  int 0x80

_read_from_stdin:
  mov eax, 3
  mov ebx, 0 ; stdin
  mov ecx, buffer_1024
  mov edx, 1023
  int 0x80
  mov eax, buffer_1024
  mov ebx, 1024
  call _print
  mov eax, 0
  call _exit

_start:
  ; checking command line args
  mov eax, [esp]
  cmp eax, 1
  je _read_from_stdin

  ; calling sys_open
  mov eax, 5
  mov ebx, [esp+8] ; argv[1]
  mov ecx, 0 ; flags
  mov edx, 0 ; mode
  int 0x80
  cmp eax, -1 ; err code check
  mov ecx, eax
  mov eax, open_file_err
  mov ebx, open_file_err_len
  jle _handle_err

  mov dword [esp], 3
  mov dword [esp+4], ecx
  mov dword [esp+8], buffer_1024
  mov dword [esp+12], 1023
  
  read_loop:
    ; calling sys_read
    mov eax, [esp]
    mov ebx, [esp+4]
    mov ecx, [esp+8]
    mov edx, [esp+12]
    int 0x80 
    cmp eax, 0
    je exit_sec

    ; calling sys_write
    mov edx, eax
    mov eax, buffer_1024
    mov ebx, edx
    call _print
    jmp read_loop

  exit_sec:
    ; calling sys_exit
    mov eax, 0
    call _exit

; eax -> ptr to string to print
; ebx -> size of string
_print:
  mov edx, ebx
  mov ebx, 1 ; stdout
  mov ecx, eax ; 1st arg
  mov eax, 4
  int 0x80
  ret

; eax -> ptr to string to print
; ebx -> size of string
_handle_err:
  call _print
  mov eax, 1
  call _exit
