import { h, Component } from 'preact';
import style from './intro.less';
import Button from '../../button/button';
import Label from '../../label/label';
import CloseButton from '../../closebutton/closebutton';

class LocalLabel extends Label {
	static defaultProps = {
		prefix: 'intro'
	};
}

const HOST_PARTS = ((window && window.location && window.location.hostname) || '').split('.');
const DOMAIN = HOST_PARTS.length > 0 ? HOST_PARTS.slice(-2).join('.') : '';

export default class Intro extends Component {

	static defaultProps = {};

	render(props, state) {

		const {
			onAcceptAll,
			onShowPurposes,
			onClose
		} = props;

		return (
			<div class={style.intro}>
				<CloseButton
					class={style.close}
					onClick={onClose}
				/>
				<div class={style.title}>
					<LocalLabel localizeKey='title'>Thanks for visiting</LocalLabel> {DOMAIN}
				</div>
				<div class={style.description}>
					<LocalLabel localizeKey='description'>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer eget sem velit. In sit amet accumsan mi. Nunc sit amet volutpat felis. Proin fermentum diam elit, ut viverra lectus eleifend a. Nam sit amet sem elit. Etiam posuere tortor ac felis gravida ullamcorper. Aliquam laoreet, massa in egestas malesuada, diam nunc ultrices libero, eget suscipit leo nisl accumsan ligula. Nullam sagittis vehicula placerat. Ut id neque elit. Vestibulum ac pharetra mauris.</LocalLabel>
				</div>
				<div class={style.options}>
					<Button
						class={style.rejectAll}
						invert={true}
						onClick={onShowPurposes}
					>
						<LocalLabel localizeKey='showPurposes'>Manage your choices</LocalLabel>
					</Button>
					<Button
						class={style.acceptAll}
						onClick={onAcceptAll}
					>
						<LocalLabel localizeKey='acceptAll'>Got it, thanks!</LocalLabel>
					</Button>
				</div>
			</div>
		);
	}
}
