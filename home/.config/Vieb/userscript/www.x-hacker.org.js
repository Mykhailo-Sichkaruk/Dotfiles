// ==UserScript==
// @name         Global Background and Text Color Change
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Change the background color to black and text color to white for all elements on the page
// @author       You
// @match        *://*/*
// @grant        none
// @run-at       document-end
// ==/UserScript==

(function() {
    'use strict';

    // Create a new style element
    var style = document.createElement('style');
    style.type = 'text/css';
    style.innerHTML = `
        body, body * {
            background-color: black !important;
            color: white !important;
        }
    `;
    // Append the style to the head of the document
    document.head.appendChild(style);
})();
