// TRIANGLE MESH
class MESH {
    // VERTICES
    int nv=0, maxnv = 1000;  
    pt[] G = new pt [maxnv];                        
    // TRIANGLES 
    int nt = 0, maxnt = maxnv*2;                           
    boolean[] isInterior = new boolean[maxnv];                                      
    // CORNERS 
    int c=0;    // current corner                                                              
    int nc = 0; 
    int[] V = new int [3*maxnt];   
    int[] O = new int [3*maxnt];  
    // current corner that can be edited with keys
  MESH() {for (int i=0; i<maxnv; i++) G[i]=new pt();};
  void reset() {nv=0; nt=0; nc=0;}                                                  // removes all vertices and triangles
  void loadVertices(pt[] P, int n) {nv=0; for (int i=0; i<n; i++) addVertex(P[i]);}
  void writeVerticesTo(pts P) {for (int i=0; i<nv; i++) P.G[i].setTo(G[i]);}
  void addVertex(pt P) { G[nv++].setTo(P); }                                             // adds a vertex to vertex table G
  void addTriangle(int i, int j, int k) {V[nc++]=i; V[nc++]=j; V[nc++]=k; nt=nc/3; }     // adds triangle (i,j,k) to V table

  // CORNER OPERATORS
  int t (int c) {int r=int(c/3); return(r);}                   // triangle of corner c
  int n (int c) {int r=3*int(c/3)+(c+1)%3; return(r);}         // next corner
  int p (int c) {int r=3*int(c/3)+(c+2)%3; return(r);}         // previous corner
  pt g (int c) {return G[V[c]];}                             // shortcut to get the point where the vertex v(c) of corner c is located

  boolean nb(int c) {return(O[c]!=c);};  // not a border corner
  boolean bord(int c) {return(O[c]==c);};  // not a border corner

  pt cg(int c) {return P(0.6,g(c),0.2,g(p(c)),0.2,g(n(c)));}   // computes offset location of point at corner c

  // CORNER ACTIONS CURRENT CORNER c
  void next() {c=n(c);}
  void previous() {c=p(c);}
  void opposite() {c=o(c);}
  void left() {c=l(c);}
  void right() {c=r(c);}
  void swing() {c=s(c);} 
  void unswing() {c=u(c);} 
  void printCorner() {println("c = "+c);}
  
  

  // DISPLAY
  void showCurrentCorner(float r) { if(bord(c)) fill(red); else fill(dgreen); show(cg(c),r); };   // renders corner c as small ball
  void showEdge(int c) {beam( g(p(c)),g(n(c)),rt ); };  // draws edge of t(c) opposite to corner c
  void showVertices(float r) // shows all vertices green inside, red outside
    {
    for (int v=0; v<nv; v++) 
      {
      if(isInterior[v]) fill(green); else fill(red);
      show(G[v],r);
      }
    }                          
  void showInteriorVertices(float r) {for (int v=0; v<nv; v++) if(isInterior[v]) show(G[v],r); }                          // shows all vertices as dots
  void showTriangles() { for (int c=0; c<nc; c+=3) show(g(c), g(c+1), g(c+2)); }         // draws all triangles (edges, or filled)
  void showEdges() {for (int i=0; i<nc; i++) showEdge(i); };         // draws all edges of mesh twice
  void showOpposites() {for (int i=0; i<nc; i++)  showEdge(i); };
  
  void triangulate()      // performs Delaunay triangulation using a quartic algorithm
   {
   c=0;                   // to reset current corner
   // **01 implement it
     pt X = P();
     float r=1;  // radius of circumcircle
     for(int i = 0; i <nv-2; i++) {
       for(int j = i+1; j < nv-1; j++) {
         for(int k = j+1; k < nv; k++) {
           X = CircumCenter(G[i], G[j], G[k]);
           r = d(X, G[i]);
           
           boolean found = false;
           for(int m = 0; m < nv; m++) {
             if((m != i) && (m != j) && (m != k) && (d(X, G[m]) <= r)) {
               found = true;
             }
           }
           if (!found) {
             if(ccw(G[i], G[j], G[k])) {
               addTriangle(i, j, k); 
             }
             if(ccw(G[k], G[j], G[i])) {
               addTriangle(k, j, i); 
             }
           }
         }  
       }
     }
   }  

   
  void computeO() // **02 implement it 
    {                                          
      // **02 implement it 
      for(int c = 0; c < nc; c++) {
        O[c]= c;
      }
      for(int c = 0; c < nc; c++) {
        for(int v = 0; v < nc; v++) {
          if(V[n(c)] == V[p(v)] && V[n(v)] == V[p(c)]) {
            O[c] = v;
            O[v] = c;
          }
        }
      }
    } 
    
  void showBorderEdges()  // draws all border edges of mesh
    {
    // **02 implement;
    for(int c = 0; c < nc; c++) {
     if(O[c] == c) {
       showEdge(c);
     }
    }
   }
   
  int countBorders()  //  counts borders
    {
    int count = 0;
      
    for(int c = 0; c < nc; c++) {
     if(O[c] == c) {
       count++; 
     }
    }
    
    return count;
   }

  void showNonBorderEdges() // draws all non-border edges of mesh
    {
    // **02 implement 
    for(int c = 0; c < nc; c++) {
      if(O[c] != c) {
        showEdge(c); 
      }
    }
   }        
    
  void classifyVertices() { 
    // **03 implement it
    for(int c = 0; c < nc; c++) {
      isInterior[V[c]] = true; 
    }
    
    for(int v = 0; v < nc; v++) {
      if(O[v] == v) {
        isInterior[V[p(v)]] = false;
        isInterior[V[n(v)]] = false;
      }
    }
  }  
    
  void smoothenInterior() { // even interior vertiex locations
    pt[] Gn = new pt[nv];
    // **04 implement it
    
    for(int v = 0; v < nv; v++) {
      
      int count = 0;
      int neighbors = 0;
      pt avg = new pt();
      
      if(isInterior[v]) {
        for(int c = 0; c < nc; c++) {
          if(V[c] == v) {
            neighbors = V[n(c)];
            count++;
            avg.add(G[neighbors]);
          }
        }
        avg.div(count);
        Gn[v] = avg; 
      }
      else {
        Gn[v] = G[v];
      }
    }
    
    for (int v=0; v<nv; v++) {
      if(isInterior[v]) {
        G[v].translateTowards(.1,Gn[v]);
      }
    }
   }


   // **05 implement corner operators in Mesh
  int v (int c) {return V[c];}                          // vertex of c
  int o (int c) {return O[c];}                          // opposite corner
  int l (int c) {return O[n(c)];}                       // left
  int s (int c) {return n(O[n(c)]);}                    // swing
  int u (int c) {return p(O[p(c)]);}                    // unswing
  int r (int c) {return O[p(c)];}                       // right

  

  void showVoronoiEdges() // draws Voronoi edges on the boundary of Voroni cells of interior vertices
  { 
    // **06 implement it
    for(int v = 0; v <nc; v++) {
      fill(yellow);
      beginShape(POLYGON);
      vertex(triCircumcenter(c));
      //swing around the corner
      for(int c = 0; c<nc; c++) {
        vertex(triCircumcenter(n(c)));
      }
      endShape(CLOSE);
    }
  }
  
  void drawVoronoiFaceofInteriorVertices() {
    float dc = 1./(nv-1);
    for(int v = 0; v < nv; v++) {
       if(isInterior[v]) {
          fill(dc*255*(nv-v), 200);
          drawVoronoiFaceOfInteriorVertex(v);
       }
    }
  }

  void drawVoronoiFaceOfInteriorVertex(int v) {
    /** implement */
    beginShape(POLYGON);
    for(int c = 0; c<nc; c++) {
      if(V[c] == v) {
        vertex(triCircumcenter(c)); 
      }
    }
    endShape(CLOSE);
  }  
  
  int cornerIndexOfVertexIndex(int v) {
    int corner = 0; 
    boolean found = false;
    int j = 0;
    while(!found) {
       if(V[j] == v) {
          corner = u(s(j));
          found = true;
       } else {
          j++; 
       }
    }
     return corner; 
  }

  void showArcs() // draws arcs of quadratic B-spline of Voronoi boundary loops of interior vertices
    { 
    // **06 implement it
    }               // draws arcs in triangles

 
  pt triCenter(int c) {return P(g(c),g(n(c)),g(p(c))); }  // returns center of mass of triangle of corner c
  pt triCircumcenter(int c) {return CircumCenter(g(c),g(n(c)),g(p(c))); }  // returns circumcenter of triangle of corner c


  } // end of MESH
