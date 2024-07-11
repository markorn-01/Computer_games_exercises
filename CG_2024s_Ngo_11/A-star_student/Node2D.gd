extends Node2D

class Astar:
	# Class to store graph node elements
	class StarNode:
		# Node name
		var name: String
		# h-cost
		var h: int
		# g-cost
		var g: int
		# Parent node
		var lastNode: StarNode
		# An array of neighbour nodes
		var neighbors = []
		
	# Default constructor 
	# n - Node name
	# cost - node cost
		func _init(n, cost):
			self.name = n
			self.h = cost
			self.g = 0
			self.lastNode = null
			
		# Function to insert the neighbours
		func insertNeighbours(n: StarNode, cost: int):
			neighbors.push_back([n, cost])
			
	# Stores the final path
	var path = []
	# List of all cities
	var _cities = []
	# Start node
	var _start: StarNode
	# Target node
	var _target: StarNode
	# Current node
	var _currentNode: StarNode
	# Open list of StarNode nodes
	var _openList = []
	# Close list of nodes
	var _closeList = []
	
	# Constructor
	func _init():
		self._cities.push_back(StarNode.new("Frankfurt", 96))
		self._cities.push_back(StarNode.new("Keiserslautern", 158))
		self._cities.push_back(StarNode.new("Ludwigshafen", 108))
		self._cities.push_back(StarNode.new("Würzburg", 0))
		self._cities.push_back(StarNode.new("Heilbronn", 87))
		self._cities.push_back(StarNode.new("Karlsruhe", 140))
		self._cities.push_back(StarNode.new("Saarbrücken", 222))

		self._cities[0].insertNeighbours(self._cities[3], 116)
		self._cities[0].insertNeighbours(self._cities[1], 103)

		self._cities[1].insertNeighbours(self._cities[2], 53)
		self._cities[1].insertNeighbours(self._cities[6], 70)
		self._cities[1].insertNeighbours(self._cities[0], 103)

		self._cities[2].insertNeighbours(self._cities[1], 53)
		self._cities[2].insertNeighbours(self._cities[3], 183)

		self._cities[3].insertNeighbours(self._cities[0], 116)
		self._cities[3].insertNeighbours(self._cities[2], 183)
		self._cities[3].insertNeighbours(self._cities[4], 102)

		self._cities[4].insertNeighbours(self._cities[3], 102)
		self._cities[4].insertNeighbours(self._cities[5], 84)

		self._cities[5].insertNeighbours(self._cities[4], 84)
		self._cities[5].insertNeighbours(self._cities[6], 145)

		self._cities[6].insertNeighbours(self._cities[5], 145)
		self._cities[6].insertNeighbours(self._cities[1], 70)

		self._start = self._cities[6]
		self._target = self._cities[3]
			
	# Print the final path
	func printPath():
		var next = _target
		while next:
			path.append(next)
			print(String(next.name) + " " + String(next.g) )
			next = next.lastNode
			
	# Save the final path 
	func finalPath():
		var next = _target
		while next:
			path.append(next)
			next = next.lastNode
			
	# Print the open list
	func printOpenList():
		for iter in _openList:
			print(String(iter[0].name) + " " + String(iter[1]))
	
	func computePath() -> bool:
		# Enter your code here. You may add new functions 
		return false
			
func _ready():
	# Create a class instance
	var pathSearch = Astar.new()
	
	# Compute and print the path
	if pathSearch.computePath():
		pathSearch.finalPath()
		var p = pathSearch.path
		var s = ""
		for i in p:
			s += i.name +  "\n"
		$Path3D.text = s
		pathSearch.printPath()
		return
	else:
		print("Error while computing path")	

