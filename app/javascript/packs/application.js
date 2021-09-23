import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require('jquery')
import 'bootstrap'

require('packs/script')
require('packs/parallax')
require('packs/select-chosen')
require('packs/slick.min')
require("jquery")
require("@nathanvda/cocoon")
