# Compiled, but why?

Honestly I didn't wanna compile them into an .exe with ps2exe due to the fact that every Windows PC comes with Powershell pre-installed nowadays *but* that quickly proven cumbersome.

Mainly, 
- They always come with a super dated Powershell version that doesn't have double-click to run functionality so they just slam you with `Powershell ISE` in your face. 
- Some people run debloat scripts, completely getting rid of Powershell while at it (why)
- People are missing Windows Terminal on their systems. Either another debloat script boogaloo, or just ancient Win10 versions

So ya, packing it into a humble little executable was the best and simple approach to solve this problem. Bash scripts equally can be compiled into an executable binary, though it's just better utilizing another language for that like Go.
