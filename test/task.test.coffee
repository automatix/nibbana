chai = require 'chai'
Task = require '../src/task/task'
Project = require '../src/task/project'
Tag = require '../src/tag/tag'
moment = require 'moment'

chai.should()

describe 'Task', ->
  describe 'get accessor', ->

    it 'should return id', ->
      t = new Task id: 'UUID'
      t.id().should.equal 'UUID'

    it 'should return name', ->
      t = new Task name: 'name'
      t.name().should.equal 'name'

    it 'should return state', ->
      t = new Task state: 0
      t.state().should.equal 0

    it 'should return parentid', ->
      t = new Task parentid: 'UUID'
      t.parentid().should.equal 'UUID'

    it 'should return "waiting for" value', ->
      t = new Task waitingfor: 'Someone'
      t.waiting_for().should.equal 'Someone'

    it 'should return task list order', ->
      t = new Task seq: 1
      t.task_order().should.equal 1

    it 'should return tags as array', ->
      t = new Task tags: ",tag1,tag2,tag3,"
      t.tags().join(',').should.equal 'tag1,tag2,tag3'

    it 'should return note', ->
      t = new Task note: 'note'
      t.note().should.equal 'note'

    it 'should return estimated time', ->
      t = new Task etime: 360
      t.estimated_time().should.equal 360

    it 'should return energy required', ->
      t = new Task energy: 3
      t.energy().should.equal 3

    it 'should return scheduled for date', ->
      t = new Task startdate: '20120814'
      t.scheduled_for().should.equal '20120814'

    it 'should return due date', ->
      t = new Task duedate: '20120814'
      t.due_date().should.equal '20120814'

  describe 'get entity accessor', ->
    it 'should return parent', ->
      fake_storage =
        get: () -> new Project( id: 'UUID-parent' )

      t = new Task( parentid: 'UUID', fake_storage )
      p = t.parent()
      p.constructor.name.should.equal 'Project'
      p.id().should.equal 'UUID-parent'

    it 'should return "waiting for" contact'
    it 'should return instances of tags as array'

  describe 'flag accessor', ->
    it 'should return focused state', ->
      t = new Task {}
      t.focus( true )
      t.is_focused().should.equal true

    it 'should return completed status', ->
      t = new Task {}
      t.complete( true )
      t.is_completed().should.equal true

    it 'should return cancelled status', ->
      t = new Task {}
      t.cancel()
      t.is_cancelled().should.equal true

    it 'should return trashed status', ->
      t = new Task {}
      t.trash( true )
      t.is_trashed().should.equal true

    it 'should return deleted status', ->
      t = new Task {}
      t.delete( true )
      t.is_deleted().should.equal true

    it 'should return logged status', ->
      t = new Task {}
      t.log( true )
      t.is_logged().should.equal true

    it 'should return recurring status', ->
      t = new Task recurring: 1
      t.is_recurring().should.equal true

    it 'should return waiting status', ->
      t = new Task {}
      t.waiting_for( 'Someone' )
      t.is_waiting().should.equal true

  describe 'set accessor', ->
    it 'should set name', ->
      t = new Task {}
      t.name( 'name' )
      t.name().should.equal 'name'

    it 'should set parentid', ->
      t = new Task {}
      t.parentid( 'uuid' )
      t.parentid().should.equal 'uuid'

    it 'should set "waiting for" value', ->
      t = new Task {}
      t.waiting_for( 'Someone' )
      t.waiting_for().should.equal 'Someone'

    it 'should set task list order', ->
      t = new Task {}
      t.task_order( 1 )
      t.task_order().should.equal 1

    it 'should set tags', ->
      t = new Task {}
      t.tags( [ "1", "2" ] )
      t.tags().join(',').should.equal '1,2'

    it 'should set note', ->
      t = new Task {}
      t.note( 'note' )
      t.note().should.equal 'note'

    it 'should set estimate time', ->
      t = new Task {}
      t.estimated_time( 360 )
      t.estimated_time().should.equal 360

    it 'should set energy required', ->
      t = new Task {}
      t.energy( 3 )
      t.energy().should.equal 3

    it 'should set start date', ->
      t = new Task {}
      target = moment([2012, 8, 10])
      t.schedule_for( target )
      set = t.scheduled_for()
      moment( set ).format( 'YYYYMMDD' ).should.equal target.format( 'YYYYMMDD' )

    it 'should set due date'
    it 'should set recurring status'

  describe 'set entity accessor', ->
    it 'should set parentid from project', ->
      p = id: 'PARENTID'
      t = new Task {}
      t.set_parent( p )
      t.parentid().should.equal 'PARENTID'

    it 'should set "waiting for" value from contact', ->
      tag = key: 'TAG'
      t = new Task {}
      t.waiting_for( tag )
      t.waiting_for().should.equal 'TAG'

    it 'should set tags from array of tag entities', ->
      tags = [ new Tag( key: '1' ), new Tag( key: '2' ) ]
      t = new Task {}
      t.tags( tags )
      t.tags().join( ',' ).should.equal '1,2'

    it 'should set start date from Date object'
    it 'should set due date from Date object'

  describe 'special accessors', ->
    it 'should return expected store key', ->
      t = new Task id: 'ABC'
      t.store_key().should.equal 'task-ABC'

    it 'should return all data as object'

    it 'should set __internal_type on exported data', ->
      t = new Task {}
      t.get_data().__internal_type.should.equal 'Task'

  describe 'api compaitbility', ->
    it 'should set modified time for property', ->
      start = Math.floor( new Date().getTime() / 1000 )
      t = new Task {}
      t.name( 'test' )
      data = t.get_data()
      data._name.should.not.be.undefined
      data._name.should.be.a 'number'
      ( data._name >= start ).should.be.true

    it 'should export all fields required'
    it 'should export due date as YYYYMMDD'
    it 'should export start date as YYYYMMDD'
    it 'should export state as valid integer'
    it 'should set seqt for focused'
    it 'should set seq for task list order'
    it 'should set deleted to timestamp for deletion'
    it 'should set completed to timestamp for completion'
    it 'should set etime to minutes estimated'
    it 'should export tags as comma delimited string'
    it 'should prefix and suffix comma to tag list'
    it 'should set parentid to parent uuid'
    it 'should provide defaults for all fields'