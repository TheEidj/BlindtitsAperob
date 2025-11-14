// src/composables/useSwipeNavigate.ts
import { ref, onMounted, onUnmounted } from "vue";
import { animate, spring } from "animejs";
import {useRouter} from "vue-router";

export function useSwipeNavigate(url: string) {
    const router = useRouter();
    const cardRef = ref<HTMLDivElement | null>(null);

    let startX = 0;
    let currentX = 0;
    let isDragging = false;
    let currentAnimation: any = null;
    const SWIPE_THRESHOLD = 80;

    const go = () => void router.push(url);
    const handleStart = (x: number) => {
        currentAnimation?.pause();
        currentAnimation = null;
        startX = x;
        currentX = 0;
        isDragging = true;
    };

    const handleMove = (x: number) => {
        if (!isDragging || !cardRef.value) return;

        currentX = x - startX;
        const el = cardRef.value;

        const rubber = (v: number, limit: number) =>
            v > limit ? limit + (v - limit) * 0.3
                : v < -limit ? -limit + (v + limit) * 0.2
                    : v;

        const move = rubber(currentX, 200);
        el.style.transform = `translateX(${move}px)`;
        el.style.opacity = `${Math.max(0.3, 1 - Math.abs(currentX) / 300)}`;
    };

    const handleEnd = () => {
        if (!isDragging || !cardRef.value) return;
        isDragging = false;

        const el = cardRef.value;

        if (currentX > SWIPE_THRESHOLD) {
            // swipe right => navigate
            currentAnimation = animate(el, {
                translateX: ["", window.innerWidth + "px"],
                opacity: 0,
                duration: 300,
                complete: () => {
                    currentAnimation = null;
                    go();
                }
            });
        } else {
            // reset
            currentAnimation = animate(el, {
                x: 0,
                opacity: 1,
                duration: 400,
                ease: spring({ bounce: .6, stiffness: 300, damping: 25 }),
                complete: () => { currentAnimation = null; }
            });
        }
    };

    const onClick = (e: MouseEvent) => {
        if (Math.abs(currentX) > 5) {
            e.preventDefault();
            e.stopPropagation();
            return;
        }
        go();
    };

    // --- DOM attach ---

    onMounted(() => {
        const el = cardRef.value;
        if (!el) return;

        // touch
        el.addEventListener("touchstart", e => {
            const t = (e as TouchEvent).touches?.[0];
            if (t) handleStart(t.clientX);
        }, { passive: true });

        el.addEventListener("touchmove", e => {
            const t = (e as TouchEvent).touches?.[0];
            if (t) handleMove(t.clientX);
        }, { passive: true });

        el.addEventListener("touchend", handleEnd);

        // mouse
        el.addEventListener("mousedown", e => { handleStart(e.clientX); e.preventDefault(); });
        document.addEventListener("mousemove", e => handleMove(e.clientX));
        document.addEventListener("mouseup", handleEnd);
    });

    onUnmounted(() => {
        const el = cardRef.value;
        if (!el) return;

        el.removeEventListener("touchstart", () => {});
        el.removeEventListener("touchmove", () => {});
        el.removeEventListener("touchend", handleEnd);
        el.removeEventListener("mousedown", () => {});
        document.removeEventListener("mousemove", () => {});
        document.removeEventListener("mouseup", handleEnd);
    });

    return { cardRef, onClick };
}
