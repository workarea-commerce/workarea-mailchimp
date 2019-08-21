/**
 * @namespace WORKAREA.mailchimpTracking
 */
WORKAREA.registerModule('mailchimpTracking', (function () {
    'use strict';

    var setCookie = function() {
            var tracking_value = WORKAREA.url.parse(document.URL).queryKey.mc_cid;

            if (_.isUndefined(tracking_value)) { return; }

            WORKAREA.cookie.create('mc_cid', tracking_value, 30);
        };
    setCookie();
}()));
