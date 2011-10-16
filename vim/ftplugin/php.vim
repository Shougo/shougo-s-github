" For error marker.
setlocal makeprg=php\ -l\ %\ $*
setlocal errorformat=%EPHP\ Parse\ error:\ %m\ in\ %f\ on\ line\ %l
                       \%WNotice:\ %m\ in\ %f\ on\ line\ %l,
                       \%EParse\ error:\ %m\ in\ %f\ on\ line\ %l,
                       \%WNotice:\ %m\ in\ %f\ on\ line\ %l,
                       \%-G%.%#
