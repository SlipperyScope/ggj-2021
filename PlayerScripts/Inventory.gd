extends Node

var Items = []

func AddItem(item):
	Items.append(item)

func RemoveItem(item):
	var i = Items.find(item)
	while i != -1:
		Items.remove(i)
		i = Items.find(item)

func HasItem(item):
	return Items.find(item) != -1
