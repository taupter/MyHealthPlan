// backend.js
.pragma library

/*
  Validate the input credential
  Return values are..
  0 - Success
  1 - credentials are empty
*/
function validateUserCredentials(ssn, birthdate)
{
    var ret
    if(ssn === "" || birthdate === "")
    {
        ret = 1
    }
    else
    {
        ret = 0
    }
    return ret
}

/*
  Validate the input credential to register
  Return values are..
  0 - Success
  1 - credentials are empty
  2 - passwords does not match
*/
function validateRegisterCredentials(user)
{
    var ret
    if(user.name === "" || user.birthdate === "" || user.ssn === "" || user.cardnumber === "" || user.datestart === "" || user.dateend === "")
    {
        ret = 1
    }
/*    else if(pword !== pword2)
    {
        ret = 2
    }*/
    else
    {
        ret = 0
    }
    return ret
}
