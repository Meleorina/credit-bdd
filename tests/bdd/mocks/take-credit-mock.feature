# Created by korwin at 10/11/18
Feature: stateful mock server

Background:
* configure cors = true
* def id = 0
* def credits = {}
* def str2int = function(arg) {return parseInt(arg);}
* def incr = function(arg) { return arg + 1;}
* def answer_gen =
"""
function(request, id){
  keys = ["person", "credit", "agreementAt","currency","duration","percent"]
  keys.forEach(function(key) {
    if (!(key in request))
      return{"code":400, "message":"Parametr missed"}
  });
  if (!(typeof request["credit"] === 'number') || request["credit"]<1000){
    return{"code":400, "message":"Inalid value of credit"}
  }
  if (!(typeof request["agreementAt"] === 'string') ||!(request["agreementAt"].
  match(/^\s*((?:19|20)\d{2})\-(1[012]|0?[1-9])\-(3[01]|[12][0-9]|0?[1-9])\s*$/))){
    return{"code":400, "message":"Invalid date format"}
  }
  if(!(typeof request["currency"] === 'string')){
    return{"code":400, "message":"Invalid currency"}
  }
  if (!(typeof request["duration"] === 'number') ||request["duration"]<6 || request["duration"]>100){
    return{"code":400, "message":"Invalid duration"}
  }
  if (!(typeof request["percent"] === 'number') ||request["perceent"]<2 || request["percent"]>100){
    return{"code":400, "message":"Invalid percent"}
  }
  return {"id":id}
}
"""


Scenario: pathMatches('/credit') && methodIs('post')
    * def credit = request
    * eval id = incr(id)
    * eval credit.id = id
    * eval credits[id] = credit
    * def response = answer_gen(request,id)

Scenario:
    # catch-all
    * def responseStatus = 404
    * def responseHeaders = { 'Content-Type': 'text/html; charset=utf-8' }
    * def response = <html><body>Not Found</body></html>
