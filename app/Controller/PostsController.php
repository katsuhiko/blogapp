<?php
App::uses('AppController', 'Controller');

/**
 * Posts Controller
 *
 */
class PostsController extends AppController {

	/**
	 * Components
	 *
	 * @var array
	 */
	public $components = ['Paginator', 'RequestHandler', 'Session'];

	/**
	 * Index
	 *
	 * @return void
	 */
	public function index() {
		$this->set('posts', $this->Paginator->paginate());
	}

	/**
	 * Add
	 *
	 * @return void
	 */
	public function add() {
		if ($this->request->is('post')) {
			$this->Post->create($this->request->data);

			if ($this->Post->save()) {
				$this->Session->setFlash(__('新しい記事を受け付けました。'));
				return $this->redirect(['action' => 'index']);
			} else {
				$this->Session->setFlash(__('記事の投稿に失敗しました。入力内容を確認して再度投稿してください。'));
			}
		}
	}
}
