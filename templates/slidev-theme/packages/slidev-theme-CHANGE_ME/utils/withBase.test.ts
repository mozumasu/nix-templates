import assert from 'node:assert/strict'
import { test } from 'node:test'
import { withBase } from './withBase.ts'

test('ルート絶対パスに base を前置する', () => {
  assert.equal(withBase('/foo.png', '/deck/'), '/deck/foo.png')
})

test('既に base 付きならそのまま返す', () => {
  assert.equal(withBase('/deck/foo.png', '/deck/'), '/deck/foo.png')
})

test('base が / のときはパスを変えない', () => {
  assert.equal(withBase('/foo.png', '/'), '/foo.png')
})

test('相対パス・URL・undefined は触らない', () => {
  assert.equal(withBase('foo.png', '/deck/'), 'foo.png')
  assert.equal(withBase('https://example.com/a.png', '/deck/'), 'https://example.com/a.png')
  assert.equal(withBase('//cdn.example.com/a.png', '/deck/'), '//cdn.example.com/a.png')
  assert.equal(withBase(undefined, '/deck/'), undefined)
})
