// src/composables/useSwipeNavigate.ts
import { ref, onMounted, onUnmounted } from "vue";
import { animate, spring } from "animejs";
import {useRouter} from "vue-router";

export function useSwipeNavigate(url: string) {
    const router = useRouter();
    const cardRef = ref<HTMLDivElement | null>(null);

    let startX = 0
    let startY = 0
    let currentX = 0
    let isDragging = false
    let isSwiping = false
    let currentAnimation: any = null
    const SWIPE_THRESHOLD = 80
    const INTENT_THRESHOLD = 10

    const go = () => void router.push(url);

    const resetTransform = (el: HTMLDivElement) => {
        el.style.transform = ''
        el.style.opacity = ''
    }

    const handleStart = (x: number, y: number) => {
        const el = cardRef.value
        if (!el) return

        currentAnimation?.pause()
        currentAnimation = null

        startX = x
        startY = y
        currentX = 0
        isDragging = true
        isSwiping = false // on ne sait pas encore si c'est un swipe
    }

    const handleMove = (x: number, y: number) => {
        const el = cardRef.value
        if (!isDragging || !el) return

        const deltaX = x - startX
        const deltaY = y - startY

        // Déterminer l'intention : scroll vertical vs swipe horizontal
        if (!isSwiping) {
            if (Math.abs(deltaY) > Math.abs(deltaX) && Math.abs(deltaY) > INTENT_THRESHOLD) {
                // Geste principalement vertical -> laisser scroller, on sort
                isDragging = false
                resetTransform(el)
                return
            }

            if (Math.abs(deltaX) > Math.abs(deltaY) && Math.abs(deltaX) > INTENT_THRESHOLD) {
                // Geste principalement horizontal -> on commence le swipe
                isSwiping = true
            } else {
                // Pas encore assez de mouvement -> ne rien faire
                return
            }
        }

        // Ici, on est en mode swipe horizontal
        currentX = deltaX

        const rubber = (v: number, limit: number) =>
            v > limit
                ? limit + (v - limit) * 0.3
                : v < -limit
                    ? -limit + (v + limit) * 0.2
                    : v

        const move = rubber(currentX, 200)
        el.style.transform = `translateX(${move}px)`
        el.style.opacity = `${Math.max(0.3, 1 - Math.abs(currentX) / 300)}`
    }

    const handleEnd = () => {
        const el = cardRef.value
        if (!isDragging || !el) return

        isDragging = false

        if (!isSwiping) {
            // Pas de swipe détecté -> rien à reset, on laisse le click gérer la nav
            return
        }

        if (currentX > SWIPE_THRESHOLD) {
            // swipe right => navigate
            currentAnimation = animate(el, {
                translateX: ['', window.innerWidth + 'px'],
                opacity: 0,
                duration: 300,
                complete: () => {
                    currentAnimation = null
                    go()
                },
            })
        } else {
            // reset
            currentAnimation = animate(el, {
                x: 0,
                opacity: 1,
                duration: 400,
                ease: spring({ bounce: 0.6, stiffness: 300, damping: 25 }),
                complete: () => {
                    currentAnimation = null
                    resetTransform(el)
                },
            })
        }
    }

    const onClick = (e: MouseEvent) => {
        // Si on a vraiment swipé, on bloque le click
        if (Math.abs(currentX) > 5) {
            e.preventDefault()
            e.stopPropagation()
            return
        }
        go()
    }

    // --- DOM attach ---

    const touchStartHandler = (e: TouchEvent) => {
        const t = e.touches?.[0]
        if (t) handleStart(t.clientX, t.clientY)
    }

    const touchMoveHandler = (e: TouchEvent) => {
        const t = e.touches?.[0]
        if (t) handleMove(t.clientX, t.clientY)
    }

    const touchEndHandler = () => handleEnd()

    const mouseDownHandler = (e: MouseEvent) => {
        handleStart(e.clientX, e.clientY)
        // On empêche la sélection texte, mais pas besoin de bloquer le scroll global
        e.preventDefault()
    }

    const mouseMoveHandler = (e: MouseEvent) => handleMove(e.clientX, e.clientY)
    const mouseUpHandler = () => handleEnd()

    onMounted(() => {
        const el = cardRef.value
        if (!el) return

        // touch
        el.addEventListener('touchstart', touchStartHandler, { passive: true })
        el.addEventListener('touchmove', touchMoveHandler, { passive: true })
        el.addEventListener('touchend', touchEndHandler)

        // mouse
        el.addEventListener('mousedown', mouseDownHandler)
        document.addEventListener('mousemove', mouseMoveHandler)
        document.addEventListener('mouseup', mouseUpHandler)
    })

    onUnmounted(() => {
        const el = cardRef.value
        if (!el) return

        el.removeEventListener('touchstart', touchStartHandler)
        el.removeEventListener('touchmove', touchMoveHandler)
        el.removeEventListener('touchend', touchEndHandler)

        el.removeEventListener('mousedown', mouseDownHandler)
        document.removeEventListener('mousemove', mouseMoveHandler)
        document.removeEventListener('mouseup', mouseUpHandler)
    })

    return { cardRef, onClick }
}