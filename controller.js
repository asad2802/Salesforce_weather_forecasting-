({
    doInit: function(component, event, helper) {
        helper.fetchForecast(component);
    },

    fetchForecast: function(component, event, helper) {
        helper.fetchForecast(component);
    },

    toggleDarkMode: function(component, event, helper) {
        component.set("v.isDarkMode", !component.get("v.isDarkMode"));
    }
})
