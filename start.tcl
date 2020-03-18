#!/usr/bin/env tclsh
global dir; set dir [file dirname [info script]]
proc path {file} { global dir; return [file join $dir $file] }
proc chime1 {} { exec play -q -V1 -v 0.4 [path chime1.ogg] }
proc chime2 {} { exec play -q -V1 -v 0.4 [path chime2.ogg] }
proc chime3 {} { exec play -q -V1 -v 1.0 [path chime3.wav] }
proc speak {msg} { exec espeak -s 140 $msg }
proc dmsg {at1 at2} {
  set t1 [clock scan $at1]
  set t2 [clock scan $at2]
  set delta [expr $t2 - $t1]
  set dmin [expr $delta / 60]
  set h [expr $dmin / 60]
  set m [expr $dmin % 60]
  set msg ""
  if {$h == 1} { set msg [concat $h "hour"] }
  if {$h > 1} { set msg [concat $h "hours"] }
  if {$m != 0} { set msg [concat $msg [concat $m "minutes"]] }
  return $msg
}
proc cond {at} {
  global now
  set t1 [clock format $now -format "%H:%M"]
  set t2 [clock format $now -format "%a %H:%M"]
  if {$at == $t1 || $at == $t2} { return 1 } else { return 0 }
}
proc c {at} { if {[cond $at]} { chime1 }}
proc s {at1 at2 msg} {
  set msg2 [concat $msg "." [dmsg $at1 $at2]]
  if {[cond $at1]} { chime2; speak $msg2 }
  if {[cond $at2]} { chime3 }
}
while {1} {
  global now; set now [clock seconds]
  source [path timetable.tcl]
  while {1} {
    set min1 [clock format $now -format "%M"]
    set min2 [clock format [clock seconds] -format "%M"]
    if {$min1 != $min2} { break } else { after 60000 }
  }
}
