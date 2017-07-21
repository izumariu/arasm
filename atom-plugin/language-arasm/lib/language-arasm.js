'use babel';

import LanguageArasmView from './language-arasm-view';
import { CompositeDisposable } from 'atom';

export default {

  languageArasmView: null,
  modalPanel: null,
  subscriptions: null,

  activate(state) {
    this.languageArasmView = new LanguageArasmView(state.languageArasmViewState);
    this.modalPanel = atom.workspace.addModalPanel({
      item: this.languageArasmView.getElement(),
      visible: false
    });

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable();

    // Register command that toggles this view
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'language-arasm:toggle': () => this.toggle()
    }));
  },

  deactivate() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    this.languageArasmView.destroy();
  },

  serialize() {
    return {
      languageArasmViewState: this.languageArasmView.serialize()
    };
  },

  toggle() {
    console.log('LanguageArasm was toggled!');
    return (
      this.modalPanel.isVisible() ?
      this.modalPanel.hide() :
      this.modalPanel.show()
    );
  }

};
