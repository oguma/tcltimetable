#!/usr/bin/env tclsh
proc speak {msg} { exec espeak -s 140 $msg }
proc chime1 {} { exec play -q -V1 -v 0.2 chime1.ogg }
proc chime2 {} { exec play -q -V1 -v 0.2 chime2.ogg }
proc chime3 {} { exec play -q -V1 -v 0.5 chime3.wav }
proc cond {at} {
  set now [clock seconds]
  set t1 [clock format $now -format "%H:%M"]
  set t2 [clock format $now -format "%a %H:%M"]
  if {$at == $t1 || $at == $t2} { return 1 } else { return 0 }
}
proc c {at} { if {[cond $at]} { chime1 }}
proc s {at1 at2 msg} {
  if {[cond $at1]} { chime2; speak $msg }
  if {[cond $at2]} { chime3 }
}

while {1} {
  c "09:00"; c "12:00"; c "15:00"; c "18:00"; c "21:00"; c "00:00"

  s "15:00" "16:00" "Clean up your room"
  s "19:00" "19:30" "Meditation"
  s "21:00" "22:00" "Write a book"

  s "Wed 20:00" "Wed 21:30" "Money management"
  after 60000
}

