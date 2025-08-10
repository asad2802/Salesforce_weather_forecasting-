({
    fetchForecast: function(component) {
        const action = component.get("c.fetch5DayForecast");
        action.setParams({ cityName: component.get("v.cityName") });

        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.forecastList", response.getReturnValue());
            } else {
                console.error("Error fetching forecast:", response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})
