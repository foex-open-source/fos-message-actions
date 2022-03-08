/* globals apex */

var FOS = window.FOS || {};
FOS.message = FOS.message || {};

/**
 * This function is showing or hiding the given success or error message.
 *
 * @param {object}   daContext                      Dynamic Action context as passed in by APEX
 * @param {object}   config                         Configuration object holding the message configuration
 * @param {string}   config.message                 String or JS function returning the message text
 * @param {string}   config.actionType              One of: showPageSuccess|hidePageSuccess|showError|clearErrors|clearError
 * @param {boolean}  [config.escape]                Whether to escape the message text
 * @param {number}   [config.config.duration]       Amount of milliseconds after that the page success message should automatically be dismissed
 * @param {string}   [config.location]              Where to display the error message, on page, inline, both
 * @param {string}   [config.pageItem]              Name of the page item which the error message should be associated with
 * @param {string}   [config.pageItems]             Name of the page items which the error message should be cleared for
 * @param {boolean}  config.clearSuccess            Whether to auto-clear success messages
 * @param {boolean}  config.clearError              Whether to auto-clear error messages
 * @param {function} [initFn]                       Javascript Initialization Code Function, it can be undefined
*/
FOS.message.action = function (daContext, config, initFn) {

    var pluginName = 'FOS - Message Actions';
    apex.debug.info(pluginName, config);

    // Allow the developer to perform any last (centralized) changes using Javascript Initialization Code setting
    if (initFn instanceof Function) {
        initFn.call(daContext, config);
    }

    var message;

    // Replacing substituting strings and escaping the message
    if (['showPageSuccess', 'showError'].indexOf(config.actionType) > -1) {

        if (config.message instanceof Function) {
            message = config.message.call(daContext);
        } else {
            message = config.message;
        }

        //  Replacing substitution strings
        //  We don't escape the message by default. We let the developer decide whether to escape
        //  the whole message, or just invidual page items via $PAGE_ITEM!HTML.
        if (message) {
            message = apex.util.applyTemplate(message, {
                defaultEscapeFilter: null
            });
        } else {
            // In case the message is empty, we will exit now as there is nothing to show
            // we will log a debug message to indicate the message is blank. This is the
            // same behaviour as our Notifications plug-in
            apex.debug.log(config.pluginName + ': the message is empty, so it is not shown!');
            return;
        }

        // Escape Special Characters attribute
        if (config.escape) {
            message = apex.util.escapeHTML(message);
        }
    }

    switch (config.actionType) {
        case 'showPageSuccess':
            FOS.message.showPageSuccess(message, config.config);
            break;
        case 'hidePageSuccess':
            FOS.message.hidePageSuccess();
            break;
        case 'showError':
            FOS.message.showError(message, config.config);
            break;
        case 'clearErrors':
            FOS.message.clearErrors(config.pageItems);
            break;
        case 'clearMessage':
            FOS.message.clearMessage(config.clearSuccess, config.clearError, config.hideAfter);
            break;
    }
};

FOS.message.showPageSuccess = function (message, config) {

    // stop any lingering auto dismisses if an existing message has already been shown
    var currentTimeoutId = FOS.message.showPageSuccess.timeoutId;
    if (currentTimeoutId) {
        clearInterval(currentTimeoutId);
        delete FOS.message.showPageSuccess.timeoutId;
    }

    // any escaping is assumed to have been done by now
    apex.message.showPageSuccess(message);

    // setup our timer to auto dismiss the message after X seconds
    if (config.duration) {
        FOS.message.showPageSuccess.timeoutId = setTimeout(function () {
            FOS.message.hidePageSuccess();
        }, config.duration);
    }
};

FOS.message.hidePageSuccess = function () {
    apex.message.hidePageSuccess();
};

FOS.message.showError = function (message, config) {

    // stop any lingering auto dismisses if an existing message has already been shown
    var currentTimeoutId = FOS.message.showError.timeoutId;
    if (currentTimeoutId) {
        clearInterval(currentTimeoutId);
        delete FOS.message.showError.timeoutId;
    }

    // optionally clear existing errors before showing the new one
    if (config.clearErrors) FOS.message.clearErrors();

    // if we associate the message with an item then we may have defined multiple page items
    if (config.pageItem && config.location.includes('inline')) {
        // Show our page item errors
        config.pageItem.split(',').forEach(function (pageItem) {
            // Show our APEX error message
            apex.message.showErrors({
                type: 'error',
                location: ['inline'],
                pageItem: pageItem,
                message: message,
                //any escaping is assumed to have been done by now
                unsafe: false
            });
        });
        // show are page level error if defined
        if (config.location.includes('page')) {
            apex.message.showErrors({
                type: 'error',
                location: ['page'],
                pageItem: undefined,
                message: message,
                //any escaping is assumed to have been done by now
                unsafe: false
            });
        }
    } else {
        // Show our error message
        apex.message.showErrors({
            type: 'error',
            location: config.location,
            pageItem: config.pageItem,
            message: message,
            //any escaping is assumed to have been done by now
            unsafe: false
        });
    }

    // setup our timer to auto dismiss the message after X seconds
    if (config.duration) {
        FOS.message.showError.timeoutId = setTimeout(function () {
            FOS.message.clearErrors();
        }, config.duration);
    }
};

FOS.message.clearErrors = function (pageItems) {
    // check if we are clearing 1 or more page items if not we then clear everything
    if (Array.isArray(pageItems) && pageItems.length > 0) {
        pageItems.forEach(function (item, index) {
            if (item) apex.message.clearErrors(item.trim());
        })
    } else {
        apex.message.clearErrors();
    }
};

FOS.message.clearMessage = function(clearSuccess, clearError, hideAfter){
    const SUCCESS_SELECTOR = 'APEX_SUCCESS_MESSAGE';
    const ERROR_SELECTOR = 'APEX_ERROR_MESSAGE';

    const successEl = document.getElementById(SUCCESS_SELECTOR);
    const errorEl = document.getElementById(ERROR_SELECTOR);

    const VISIBLE_CLS = 'u-visible';
    const HIDDEN_CLS = 'u-hidden';

    apex.message.setThemeHooks({
        beforeShow: function(msgType, msgEl){
            console.log(msgEl);
            if((clearSuccess && msgType == 'success') || (clearError && msgType === 'error')){
                setTimeout(function(){
                    msgEl.removeClass(VISIBLE_CLS).addClass(HIDDEN_CLS);
                }, hideAfter);
            }
        }
    })

    // const observerConfig = {
    //     attributes: true,
    //     attributeFilter: ['class'],
    //     childList: true,
    //     subtree: false
    // };

    // const callback = function(mutationsList, observer){
    //     console.log('mutationList', mutationsList);
    //     for(const mutation of mutationsList){
    //         if(mutation.type === 'childList'){
    //             if(mutation.addedNodes.length > 0){
    //                 console.log('A Node has been added', mutation.addedNodes[0]);
    //                 console.log(mutation);
    //             }

    //             if(mutation.removedNodes.length > 0){
    //                 console.log('A Node has been removed', mutation.removedNodes[0]);
    //                 console.log(mutation);
    //             }
    //         }
    //     }
    // }

    // const observer = new MutationObserver(callback);

    // if(clearSuccess && successEl){
    //     observer.observe(successEl,observerConfig);
    // }

    // if(clearError && errorEl){
    //     observer.observe(errorEl,observerConfig);
    // }

}



