# deploy: .elvish/lib/kak.elv
fn find-session {
  fname = .kaksession
  for _ [(range 6)] {
    if ?(test -f $fname) {
      cat $fname | take 1
      return
    }
    fname = ../$fname
  }
  put ''
}

fn kak [@a]{
  if (and (>= (count $a) 1) (has-value [-c -s -d -p -l] $a[0])) {
    e:kak $@a
    return
  }

  session = (find-session)
  if (eq $session '') {
    e:kak $@a
    return
  }
  if (not (has-value [(e:kak -l)] $session)) {
    e:kak -d -s $session
  }
  e:kak -c $session $@a
}

fn kill-kak [@a]{
  session = (find-session)
  if (not (eq $session '')) {
    echo kill | e:kak -p $session
  } else {
    echo 'No session configured'
  }
}
