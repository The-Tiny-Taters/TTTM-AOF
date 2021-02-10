////////////////////////
/// Made by Team AOF ///
////////////////////////

events.listen('item.tags', function (event) {
  
  // Salt
  event.get('c:salt_dusts').add('croptopia:salt')
  event.get('c:salt_ores').add('croptopia:salt_ore')

 
 // Chests
 var charm_chests = [
  "oak",
  "spruce",
  "birch",
  "jungle",
  "acacia",
  "dark_oak",
  "crimson",
  "warped",
];

var be_chests = [
  "mossy_glowshroom",
  "pythadendron",
  "end_lotus",
  "lacugrove",
  "dragon_tree",
];

  charm_chests.forEach(function (item, index) {
  event.get("c:wooden_chests").add("charm:" + item + "_chest")
  event.get("c:wooden_chests").add("charm:" + item + "_trapped_chest")
});

be_chests.forEach(function (item, index) {
  event.get("c:wooden_chests").add("betterend:" + item + "_chest")
});

 // Barrels
 var blockus_barrels = [
  "charred",
  "white_oak",
  "bamboo",
];

blockus_barrels.forEach(function (item, index) {
  event.get("charm:barrels").add("blockus:" + item + "_barrel")
});
  
});
