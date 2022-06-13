function submitChangeColor(){
    var changeColor = document.getElementById('BodyColor');
    changeColor.setAttribute('style', 'background:blue');

    MyJSChannel.postMessage('Hello Flutter from JS');
}

function sendOk(){
    var changeColor = document.getElementById('BodyColor');
    changeColor.setAttribute('style', 'background:black');
}