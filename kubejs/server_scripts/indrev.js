////////////////////////
/// Made by Team AOF ///
////////////////////////


events.listen("recipes", function (event) {
    event.recipes.indrev.compress({
        
        ingredients: {
            item: "techreborn:iron_plate",
            count: 4
        },
        output: {
            item: "indrev:empty_upgrade",
            count: 1
        },
        processTime: 300
    });
});
