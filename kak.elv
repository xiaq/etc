# deploy: .elvish/lib/kak.elv

fn find-session [dir]{
  @parts = (splits / $dir| drop 1)
  for i [(range (count $parts))] {
    dir = /(joins / $parts[:(- (count $parts) $i)])
    if ?(test -f $dir/.kakroot) {
      joins - [(cat $dir/.kakroot)
               (explode $parts[(- (count $parts) $i):])]
      return
    }
  }
  put ''
}

fn kill [session]{
  echo kill | e:kak -p $session
}

fn kak [@a]{
  if (and (>= (count $a) 1) (has-value [-c -s -d -p -l] $a[0])) {
    e:kak $@a
    return
  }

  session = ''
  if (eq (count $a) 0) {
    session = (find-session $pwd)
  } else {
    session = (find-session (path-dir (path-abs $a[0])))
  }

  if (eq $session '') {
    e:kak $@a
    return
  }
  if (not (has-value [(e:kak -l)] $session)) {
    e:kak -s $session $@a
  } else {
    e:kak -c $session $@a
  }
}
