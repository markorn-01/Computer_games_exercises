# Name:        Quang Minh, Ngo;      student no.: 4742554
# Coauthor:    Taha Beytullah Erkoc; student no.: 4740805
# faculty:     Mathematics and Computer Science
# discipline:  Data and Computer Science


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
		func _init(n: String, cost: int):
			self.name = n
			self.h = cost
			self.g = 0
			self.lastNode = null
			
		# Function to insert the neighbours
		func insertNeighbours(n: StarNode, cost: int):
			self.neighbors.append([n, cost])
			
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
			print(str(next.name) + " " + str(next.g))
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
			print(str(iter[0].name) + " " + str(iter[1]))
	
	# Comparison function for sorting based on f cost
	func _compare_cost(a, b):
		if int(a[1]) < int(b[1]):
			return true
		return false

	func computePath() -> bool:
		_openList.append([_start, _start.h])
		
		while _openList.size() > 0:
			# Sort the open list manually based on f cost using the comparison function
			_openList.sort_custom(_compare_cost)
			_currentNode = _openList.pop_front()[0]
			
			if _currentNode == _target:
				return true
			
			_closeList.append(_currentNode)
			
			for neighbor in _currentNode.neighbors:
				var neighborNode = neighbor[0]
				var travelCost = neighbor[1]
				
				if _closeList.has(neighborNode):
					continue
				
				var tentative_g = _currentNode.g + travelCost
				var inOpenList = false
				
				for openNode in _openList:
					if openNode[0] == neighborNode:
						inOpenList = true
						if tentative_g < neighborNode.g:
							neighborNode.g = tentative_g
							neighborNode.lastNode = _currentNode
							openNode[1] = neighborNode.g + neighborNode.h
						break
				
				if not inOpenList:
					neighborNode.g = tentative_g
					neighborNode.lastNode = _currentNode
					_openList.append([neighborNode, neighborNode.g + neighborNode.h])
			
			printOpenList()
		
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


# Please suggest new heuristic costs in the graph, so that the A* algorithm visits
# less nodes to find the path than using the provided heuristic costs.
#
#
#
# To minimize the number of nodes visited, we need to ensure that the A* Algorithm
# favors the shortest path at each update step.
#
# Starting from Saarbrücken, the cost for reaching Kaiserslautern (the shortest path)
# is already lower than the cost for reaching Karlsruhe. Therefore, no changes are needed at this step.
#
# From Kaiserslautern, the algorithm currently moves to Ludwigshafen, but later finds that
# going to Frankfurt is less costly. To prioritize Frankfurt earlier, we need to adjust its heuristic value.
# Initially, the open list looks like this:
#
# [Ludwigshafen: 231, Frankfurt: 269, Karlsruhe: 285]
#
# By changing Frankfurt's heuristic cost from 96 to 1, the open list updates to:
#
# [Frankfurt: 174, Ludwigshafen: 231, Karlsruhe: 285]
#
# This change ensures that the algorithm selects Frankfurt as the next stop.
#
# From Frankfurt, the open list appears as follows:
#
# [Ludwigshafen: 231, Karlsruhe: 285, Würzburg: 289]
#
# Since Würzburg's heuristic value cannot be lowered further (h=0), we need to increase
# the heuristic values for Ludwigshafen and Karlsruhe to prioritize Würzburg.
#
# We do this by changing Ludwigshafen's heuristic cost from 108 to 168 and Karlsruhe's from 140 to 145.
#
# Consequently, the open list becomes:
#
# [Würzburg: 289, Karlsruhe: 290, Ludwigshafen: 291]
# 
# ensuring the algorithm selects Würzburg as the next and last stop.
#
# With these adjustments, the algorithm reaches its destination with fewer steps.

