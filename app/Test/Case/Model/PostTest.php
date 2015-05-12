<?php
App::uses('Post', 'Model');
App::uses('Fabricate', 'Fabricate.Lib');

/**
 * Post Test Case
 *
 */
class PostTest extends CakeTestCase {

	/**
	 * Fixtures
	 *
	 * @var array
	 */
	public $fixtures = [
		'app.post'
	];

	/**
	 * setUp method
	 *
	 * @return void
	 */
	public function setUp() {
		parent::setUp();
	}

	/**
	 * tearDown method
	 *
	 * @return void
	 */
	public function tearDown() {
		parent::tearDown();
	}

	/**
	 * @dataProvider exampleValidationErrors
	 */
	public function testバリデーションエラー($column, $value, $message) {
		$Post = Fabricate::build('Post', [$column => $value]);

		$this->assertFalse($Post->validates());
		$this->assertEquals([$message], $Post->validationErrors[$column]);
	}

	public function exampleValidationErrors() {
		return [
			['title', '', 'タイトルは必須入力です'],
			['title', str_pad('', 256, 'a'), 'タイトルは255文字以内で入力してください']
		];
	}
}
