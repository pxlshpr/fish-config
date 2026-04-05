function fixurl
    set url (pbpaste | string replace -ra '\s' '')
    echo $url | pbcopy
    echo $url
end
