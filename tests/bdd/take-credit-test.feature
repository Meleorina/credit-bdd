# Created by korwin at 10/11/18
Feature: integration test

Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def catsServerMock = serverConfig('take-credit-mock')
    * url 'http://localhost:' + catsServerMock.port + '/credit'
    * def afterScenario = function(){ catsServerMock.stop() }
    * configure headers = { 'Content-Type': 'application/json' }

Scenario: create credit positive
    Given request {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":2000000,"agreementAt":"2018-10-08","currency":"USD","duration":60,"percent":10}
    When method post
    Then status 200
    And match response == { id:'#number' }

    Given url 'http://localhost:' + catsServerMock.port + '/__admin/stop'
    When method get
    Then status 200


