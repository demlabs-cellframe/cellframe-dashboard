import QtQuick 2.0

Item {
    id: root

    //litle beatifuler visual json,
    function beatifulerJSON(json, message){
        console.log( (typeof message != 'undefined' ? message + ', ' : "")
                    , ':',  JSON.stringify(json, null, '    ') )               //невыводит на больших массивах данных
    }

    function beatifulerJSONKeys(json, message){
        console.log( (typeof message != 'undefined' ? message + ', ' : "")
                    , 'Keys:',  JSON.stringify(Object.keys(json)
                    , null, '    ') )
    }

    function validEmail(email){
        var regExp = /^[\w\.\d-_+]+@[\w\.\d-_+]+\.\w{2,4}$/i;      //maybe $ in the end
        return regExp.test(email)
    }

    function validDomain(domain){
        console.log("domain", domain)
        var regExp = /^(?!\-)(?:[a-zA-Z\d\-]{0,62}[a-zA-Z\d]\.){1,126}(?!\d+)[a-zA-Z\d]{2,4}$/;
        return regExp.test(domain)
    }

    function validDate(date){
        var regExp = /^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$/m;
        return regExp.test(date)
    }

    function replaceChars(text, findChar, replaceChar){
        return text.split(findChar).join(replaceChar)
    }
}   //root















