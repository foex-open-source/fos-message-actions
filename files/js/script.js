window.FOS		   = window.FOS			|| {};
window.FOS.message = window.FOS.message || {};

FOS.message.action = function(daContext, config){

    apex.debug.info('FOS - Message Actions', config);

	var message;

    // Replacing substituting strings and escaping the message
    if(['showPageSuccess', 'showError'].indexOf(config.actionType) > -1){

        if(config.message instanceof Function){
            message = config.message.call(daContext);
        } else {
            message = config.message;
        }

        // In case the message is empty, we at least print out an empty space
        // Otherwise APEX would show #SUCCESS_MESSAGE#
        // applyTemplate and escapeHTML also throw errors if no value is provided
        if(message === '' || message === null || message === undefined){
            message = ' ';
        }

        //  Replacing substitution strings
        //  We don't escape the message by default. We let the developer decide whether to escape
        //      the whole message, or just invidual page items via $PAGE_ITEM!HTML.
        message = apex.util.applyTemplate(message, {
            defaultEscapeFilter: null
        });

        // Escape Special Characters attribute
        if(config.escape){
            message = apex.util.escapeHTML(message);
        }
    }

	switch(config.actionType) {
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
			FOS.message.clearErrors();
			break;
		default:
			break;
	}
};

FOS.message.showPageSuccess = function(message, config){

    var currentTimeoutId = FOS.message.showPageSuccess.timeoutId;
    if(currentTimeoutId){
        clearInterval(currentTimeoutId);
        FOS.message.showPageSuccess.timeoutId = undefined;
    }

    //any escaping is assumed to have been done by now
    apex.message.showPageSuccess(message);

    if(config.duration){
        FOS.message.showPageSuccess.timeoutId = setTimeout(function(){
            FOS.message.hidePageSuccess();
        }, config.duration);
    }
}

FOS.message.hidePageSuccess = function(){
	apex.message.hidePageSuccess();
}

FOS.message.showError = function(message, config){
	apex.message.showErrors({
        type: 'error',
        location: config.location,
        pageItem: config.pageItem,
        message: message,
        //any escaping is assumed to have been done by now
        unsafe: false
	});
}

FOS.message.clearErrors = function(){
	apex.message.clearErrors();
}


