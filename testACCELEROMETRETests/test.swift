//
//  test.swift
//  testACCELEROMETRETests
//
//  Created by AVETISSIAN VAHE on 15/11/2022.
//

import Foundation

var p0c = Math.sqrt(Math.pow(c.x-p0.x,2)+
                    Math.pow(c.y-p0.y,2)); // p0->c (b)
var p1c = Math.sqrt(Math.pow(c.x-p1.x,2)+
                    Math.pow(c.y-p1.y,2)); // p1->c (a)
var p0p1 = Math.sqrt(Math.pow(p1.x-p0.x,2)+
                     Math.pow(p1.y-p0.y,2)); // p0->p1 (c)
return Math.acos((p1c*p1c+p0c*p0c-p0p1*p0p1)/(2*p1c*p0c));
