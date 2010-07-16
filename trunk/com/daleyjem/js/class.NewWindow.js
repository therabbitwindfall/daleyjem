NewWindow.prototype.overlay;
NewWindow.prototype.window;
NewWindow.prototype.theBody;
NewWindow.prototype.isIE6 = false;
NewWindow.prototype.opacity;
NewWindow.prototype.shadowLevels = 5;

function NewWindow(params) {
    var me = this;
    var overlayColor = (params.overlayColor) ? (params.overlayColor) : ("#000");
    var overlayOpacity = (params.overlayOpacity) ? (params.overlayOpacity) : (.75);
    this.opacity = overlayOpacity * 100;
    this.theBody = document.getElementsByTagName("body")[0];

    if (params.shadowLevels != null) this.shadowLevels = params.shadowLevels;

    if (navigator.userAgent.indexOf("MSIE 6") > -1) this.isIE6 = true;

    if (params.id) {
        this.CreateWindowContainer(document.getElementById(params.id));
    }

    if (params.url) {

    }

    if (params.html) {

    }

    if (params.closeButton) {
        if (typeof (params.closeButton) == "string") params.closeButton = [params.closeButton];
        var closeButtonCount = params.closeButton.length;
        for (var closeButtonIndex = 0; closeButtonIndex < closeButtonCount; closeButtonIndex++) {
            var closeButton = document.getElementById(params.closeButton[closeButtonIndex]);
            closeButton.style.cursor = "pointer";
            closeButton.onclick = function() {
                me.close();
            }
        }
    }

    this.CreateOverlay(overlayColor, overlayOpacity);

}

NewWindow.prototype.CreateWindowContainer = function(_windowNode) {
    var shadowLevels = this.shadowLevels;
    windowNode = _windowNode.cloneNode(true);
    _windowNode.parentNode.removeChild(_windowNode);
    var windowContainer = document.createElement("div");
    windowContainer.style.position = "fixed";
    if (this.isIE6) windowContainer.style.position = "absolute";
    windowContainer.style.left = "50%";
    windowContainer.style.top = "50%";
    windowContainer.style.zIndex = 1001;
    windowNode.style.display = "block";
    windowNode.style.position = "absolute";
    windowNode.style.left = "0";
    windowNode.style.top = "0";
    windowNode.style.zIndex = 1001 + shadowLevels;
    windowContainer.style.display = "none";
    windowContainer.appendChild(windowNode);
    windowContainer.style.visibility = "hidden";
    windowContainer.style.display = "block";

    this.window = windowContainer;
    this.theBody.insertBefore(windowContainer, this.theBody.childNodes[0]);

    var opacityInc = Math.floor(+this.opacity / shadowLevels);
    var shadowOpacity = +this.opacity;

    for (var shadowIndex = 0; shadowIndex < shadowLevels; shadowIndex++) {
        shadowOpacity -= opacityInc;
        var shadowNode = document.createElement("div");
        shadowNode.style.position = "absolute";
        shadowNode.style.zIndex = 1001 + shadowIndex;
        shadowNode.style.left = (shadowIndex + 1) + "px";
        shadowNode.style.top = (shadowIndex + 1) + "px";
        shadowNode.style.width = windowNode.offsetWidth + "px";
        shadowNode.style.height = windowNode.offsetHeight + "px";
        shadowNode.style.opacity = shadowOpacity / 100;
        shadowNode.style.filter = "alpha(opacity=" + shadowOpacity + ")";
        shadowNode.style.backgroundColor = "#000";
        windowContainer.appendChild(shadowNode);
    }

    windowContainer.style.marginLeft = (-1 * (windowNode.offsetWidth / 2)) + "px";
    windowContainer.style.marginTop = (-1 * (windowNode.offsetHeight / 2)) + "px";
    windowContainer.style.display = "none";
    windowContainer.style.visibility = "visible";
}

NewWindow.prototype.CreateOverlay = function(overlayColor, overlayOpacity) {
    var me = this;
    var overlayDiv = document.createElement("div");
    overlayDiv.style.position = "fixed";
    if (this.isIE6 == true) overlayDiv.style.position = "absolute";
    overlayDiv.style.zIndex = 1000;
    overlayDiv.style.left = "0px";
    overlayDiv.style.top = "0px";
    overlayDiv.style.width = "100%";
    overlayDiv.style.height = "100%";
    overlayDiv.style.backgroundColor = overlayColor;
    overlayDiv.style.opacity = overlayOpacity;
    overlayDiv.style.filter = "alpha(opacity=" + (overlayOpacity * 100) + ")";
    overlayDiv.style.display = "none";
    overlayDiv.style.parent = this;

    overlayDiv.onclick = function() {
        me.close();
    }

    this.overlay = overlayDiv;
    this.theBody.insertBefore(overlayDiv, this.theBody.childNodes[0]);
}

NewWindow.prototype.open = function() {
    var overlayDiv = this.overlay;
    overlayDiv.style.display = "block";
    this.window.style.display = "block";

    if (this.isIE6 == true) {
        if (document.documentElement.scrollHeight > overlayDiv.offsetHeight) {
            overlayDiv.style.height = document.documentElement.scrollHeight + "px";
        }

        if (document.documentElement.clientWidth > overlayDiv.offsetWidth) {
            overlayDiv.style.width = document.documentElement.clientWidth + "px";
        }

        if (overlayDiv.offsetHeight < this.theBody.offsetHeight) {
            overlayDiv.style.height = this.theBody.offsetHeight + "px";
        }
    }
}

NewWindow.prototype.close = function() {
    this.overlay.style.display = "none";
    this.window.style.display = "none";
    this.onWindowClose();
}

NewWindow.prototype.dispose = function() {
    this.theBody.removeChild(this.overlay);
    this.theBody.removeChild(this.window);
}

NewWindow.prototype.onWindowClose = function() { }