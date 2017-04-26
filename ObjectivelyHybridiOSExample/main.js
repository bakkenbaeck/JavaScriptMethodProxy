var count = 0

function sendCount(){
    var message = {"count":count}
    window.webkit.messageHandlers.SOFAHost.postMessage(message)
}

function storeAndShow(updatedCount){
    count = updatedCount
    document.querySelector("#resultDisplay").innerHTML = count
    return count
}

var SOFA = {
initialize: function() {
    setTimeout(function(){ console.log(SOFAHost.getAccounts()); }, 1000);
    setTimeout(function(){ console.log(SOFAHost.approveTransaction("<transaction data json>")); }, 2000);
    setTimeout(function(){ console.log(SOFAHost.signTransaction("<transaction data json>")); }, 3000);
    return true;
}
}
