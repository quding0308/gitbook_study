### 求最短路径

参考：https://github.com/raywenderlich/swift-algorithm-club/tree/master/Dijkstra%20Algorithm

``` Swift
class Vertex {
    var identifier: String
    
    var neighbours: [(Vertex, Double)] = []
    
    var pathLengthFromStart = Double.infinity
    
    var pathVerticesFromStart: [Vertex] = []
    
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    func clearCache() {
        pathLengthFromStart = Double.infinity
        pathVerticesFromStart = []
    }
}

extension Vertex: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }
}

extension Vertex: Equatable {
    public static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

class Dijkstra {
    
    private var totalVertices: Set<Vertex>
    
    public init(vertices: Set<Vertex>) {
        totalVertices = vertices
    }
    
    func clearCache() {
        totalVertices.forEach { vertex in
            vertex.clearCache()
        }
    }
    
    func findShortestPaths(from startVertex: Vertex) {
        clearCache()
        startVertex.pathLengthFromStart = 0
        startVertex.pathVerticesFromStart.append(startVertex)
        
        //Here starts the main part. We will use while loop to iterate through all vertices in the graph.
        //For this purpose we define currentVertex variable which we will change in the end of each while cycle.
        var curVertex: Vertex? = startVertex
        
        while let vertex = curVertex {
            
            //an implementation of setting vertex as visited
            //As it has been said, we should check only unvisited vertices in the graph,
            //So why don't just delete it from the set?
            //This approach let us skip checking for *"if !vertex.visited then"*
            totalVertices.remove(vertex)
            
            let filteredNeighbours = vertex.neighbours.filter { (vertex, weight) -> Bool in
                return totalVertices.contains(vertex)
            }
            
            //Let's iterate through them
            for neighbour in filteredNeighbours {
                let neighbourVertex = neighbour.0
                let neighbourWeight = neighbour.1
                
                let theoreticNewWeight = vertex.pathLengthFromStart + neighbourWeight
                
                if theoreticNewWeight < neighbourVertex.pathLengthFromStart {
                    neighbourVertex.pathLengthFromStart = theoreticNewWeight
                    
                    neighbourVertex.pathVerticesFromStart = vertex.pathVerticesFromStart
                    
                    neighbourVertex.pathVerticesFromStart.append(neighbourVertex)
                }
            }
            
            //If totalVertices is empty, i.e. all vertices are visited
            //Than break the loop
            if totalVertices.isEmpty {
                curVertex = nil
                break
            }
            
            //If loop is not broken, than pick next vertex for checkin from not visited.
            //Next vertex pathLengthFromStart should be the smallest one.
            curVertex = totalVertices.min(by: { (v1, v2) -> Bool in
                return v1.pathLengthFromStart < v2.pathLengthFromStart
            })
        }
    }
}
```