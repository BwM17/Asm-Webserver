;;Syscalls   
SYS_EXIT equ 1   
SYS_CLOSE equ 3 
SYS_WRITE equ 4  
SYS_SOCKET equ 41
SYS_SETSOCKOPTS equ 54 
STDOUT equ 1

;;SOCKOPTS
AF_INET equ 2
SOCK_STREAM equ 1 
SOL_SOCKET equ 1
SO_REUSEADDR equ 2

section .data  
  exit: db "EXITING CODE",10
  lexit equ $ - exit
  
  sockerr: db "SOCKET_ERROR",10 
  lsockerr equ $ - sockerr 

  closerr: db "CLOSE_ERR", 10
  lcloserr equ $ - closerr

section .bss  
  sock: resw 2 
  client: resw 2  
  sockaddr: resq 2


section .text 
  global _start 


_start:  
  call _socket 
  call _setsockopt
  call _close 


_socket:  
  mov rax, SYS_SOCKET
  mov rdi, AF_INET
  mov rsi, SOCK_STREAM
  mov rdx, 0  

  int 0x80 

  cmp rax, 0
  jle _sockerr
  mov [sock], rax
  
;;_create sockaddr

_setsockopt:
  mov rax, [sock]           ;the file_descriptor of the sock
  mov rbx, SOL_SOCKET       ;the level of the socket 
  mov rcx, SO_REUSEADDR     ;the option name SO_REUSEADDR
  mov rdi, 1                ;opt val  
  mov rsi, rdi              ;opt len
  syscall

  cmp rax, 0
  jle _closerr



;_bind:  
;  mov rax, [sock] 
;  mov rbx, 

;_listen:  
;_accept 
;_create 
;_recv 
;



_close:   
  mov rax, [sock]  
  int 0x80  

  cmp rax, 0
  jle _exit


_sockerr:
  mov rax, SYS_WRITE 
  mov rbx, STDOUT 
  mov rcx, sockerr
  mov rdx, lsockerr
  int 0x80 
  

_closerr: 
  mov rax, SYS_WRITE
  mov rbx, STDOUT
  mov rcx, closerr
  mov rdx, lcloserr 
  int 0x80


_exit:    
  mov rax, SYS_WRITE
  mov rbx, STDOUT 
  mov rcx, exit 
  mov rdx, lexit  
  int 0x80

  mov rax, SYS_EXIT 
  xor rbx, rbx   
  int 0x80


  mov rax, SYS_EXIT 
  xor rbx, rbx
  syscall 





