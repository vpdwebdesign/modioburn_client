// Common Javascript functions

function getFirstWord(stringToSplit, separator)
{
    var arrayOfWords = stringToSplit.split(separator);
    return arrayOfWords[0];
}

function capitalize(token)
{
    var newString = '';
    for (var i = 0; i < token.length; ++i)
    {
        if (i == 0)
        {
            newString += token.charAt(i).toUpperCase();
            continue;
        }
        newString += token.charAt(i)
    }

    return newString;
}
