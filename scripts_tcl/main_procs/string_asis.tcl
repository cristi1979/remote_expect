#] [ $ { } \	regexp: {[][${}\\]}
proc string_asis {data} {
  regsub -all -- \\\\ $data \\\\\\\\ data
  regsub -all -- \\\] $data \\\\\] data
  regsub -all -- \\\[ $data \\\\\[ data
  regsub -all -- \\\$ $data \\\\\$ data
  regsub -all -- \\\{ $data \\\\\{ data
  regsub -all -- \\\} $data \\\\\} data
  regsub -all -- \\\| $data \\\\\| data
  regsub -all -- \\\( $data \\\\\( data
  regsub -all -- \\\) $data \\\\\) data
  regsub -all -- \\\? $data \\\\\? data
#   regsub -all -- \\\; $data \\\\\; data
#   regsub -all -- \\\& $data \\\\\& data
#   regsub -all -- \\\" $data \\\\\" data
  return $data
}
