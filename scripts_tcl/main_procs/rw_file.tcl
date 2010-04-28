proc read_file {filename} {
  set ::file_data ""
  if {[file isfile "$filename"]} {
    set fp [open "$filename" r]
    set ::file_data [string_asis [read $fp]]
    close $fp
    return $::OK
  } else {
    puts "\n\tERR: Error reading file $filename."
    return $::ERR_GENERIC
  }
}

proc write_file {filename} {
  set fp [open "$filename" "w"]
  puts -nonewline $fp $::file_data
  close $fp
  return $::OK
}
